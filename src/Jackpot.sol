pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/*
    @title EVM.GG JACKPOT
    @author owen.eth
    @notice A Chainlink VRF Jackpot game. 
*/

contract Jackpot is VRFConsumerBaseV2 {

    /* 
    @dev Chainlink settings
    @notice see https://docs.chain.link/docs/vrf-contracts/#configurations 
    */
    VRFCoordinatorV2Interface COORDINATOR;
    LinkTokenInterface LINKTOKEN;
    address constant link_token_contract = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    uint64 s_subscriptionId;
    address vrfCoordinator;
    bytes32 keyHash;
    uint32 constant callbackGasLimit = 100000;
    uint16 constant requestConfirmations = 3;
    uint32 constant numWords =  1;
    uint256 constant chainlink_fee = 0.25 ether; //.25 link fee for oracle
    /*

    @dev Initalize contract with Chainlink VRF subscription information
    @param
        * uint64 subscriptionId => Chainlink subscription id
        * address vrf => Address of the Chainlink VRF coordinator
        * bytes32 keyhash =>  Gaslane configuration
    @notice see https://vrf.chain.link/
    */
    constructor(uint64 subscriptionId, address vrf, bytes32 keyhash) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link_token_contract);
        s_subscriptionId = subscriptionId;
        vrfCoordinator = vrf;
        keyHash = keyhash;
    }

    /* 
        @dev Jackpot settings 
        @notice Casting block.timestamp to uint32 is valid until the year 2106
             * Cutting our gas costs at the expense of the future generation 😎 *
    */
    struct GAME {
       address winner;
       uint96 amount;
       uint32 timeBegin;
       uint32 timeEnd;
       bool active;
    }
    mapping(uint256 => GAME) public history;
    uint256 constant public DEPOSIT_STEP = 0.01 ether;
    uint256 constant public DEPOSIT_LIMIT = 1 ether;
    uint32 constant public JACKPOT_TIMER = 2 minutes;
    uint256 public currGameId;
    uint256 public jackpotTotalTickets;
    address payable[] public jackpotTickets;

    /*
    @dev Deposit to the jackpot
        * Require msg.value is within deposit restrictions (DEPOSIT_STEP <= msg.value <= DEPOSIT LIMIT)
        * Require game is active and block.timestamp is before game expiry
        * Start countdown of a new game if one doesn't exist
        * Allocate tickets for msg.sender in steps of DEPOSIT_STEP in equivelance to msg.value (ie 1 eth == 100 tickets)
    */
    function deposit() public payable {
        require(msg.value <= DEPOSIT_LIMIT && msg.value >= DEPOSIT_STEP, "Deposit is less or more than the deposit restrictions");
        GAME memory game = history[currGameId];
        if (game.active) {require(uint32(block.timestamp) < game.timeEnd, "Timer expired, waiting for spin to be called");}
        else {game.active = true; game.timeBegin = uint32(block.timestamp); game.timeEnd = uint32(block.timestamp) + JACKPOT_TIMER;}

        game.amount += uint96(msg.value);
        for(uint i = 0; i < msg.value / DEPOSIT_STEP; i++) {
            jackpotTickets[jackpotTotalTickets] = payable(msg.sender);
            jackpotTotalTickets += 1;
        }
    }

    /*
    @dev Initiate Chainlink VRF Request
        * Require the game exists and the timer has expired
        * Give caller SPIN_REWARD % of the pot to promote autonomous function calls
        * Request random number from COORDINATOR 
        TODO: Decide if call will be funded by the contract, user, or subscription service
        TODO: Reward spin caller?
    */
    function spin() public {
        GAME memory game = history[currGameId];
        require(game.active == true && uint32(block.timestamp) >= game.timeEnd, "Timer not expired");
        LINKTOKEN.transferAndCall(address(COORDINATOR), chainlink_fee, abi.encode(s_subscriptionId));
        COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    /* 
    @dev Chainlink VRF Callback 
        * Retrieves a random number and picks a winning ticket
        * Sends the winnings
        * Closes game and resets jackpot 
    @param
        * [UNUSED] uint256 (requestId) => The requestId made from COORDINATOR.requestRandomWords() 
        * uint256[] memory randomWords => A list of random ints
    */
    function fulfillRandomWords(
        uint256,
        uint256[] memory randomWords
    ) internal override {
        uint256 winningTicket = (randomWords[0] % jackpotTotalTickets) + 1; 
        address payable winner = jackpotTickets[winningTicket];
        history[currGameId].active = false;
        history[currGameId].winner = winner;
        winner.transfer(uint256(history[currGameId].amount));
        currGameId += 1;
        jackpotTotalTickets = 0;
        delete jackpotTickets;
    }
}