# EVM.GAMES || EVM.GG SMART CONTRACTS
This repository contains the Solidity contracts for [evm-games](https://github.com/owenwahlgren/evm-games).
Written and tested within the [Foundry](https://github.com/gakonst/foundry) framework

- [Requirements](#requirements)
- [Quickstart](#quickstart)
- [Testing](#testing)
-  [Setup](#setup)
- [Deploying](#deploying)
- [Working with a local network](#working-with-a-local-network)
- [Working with other chains](#working-with-other-chains)
- [Security](#security)
- [Contributing](#contributing)
- [Resources](#resources)
- [TODO](#todo)

## Requirements

  

An installation of Foundry is required:

- [Foundry / Foundryup](https://github.com/gakonst/foundry)

- This will install `forge`, `cast`, and `anvil`

- You can test you've installed them right by running `forge --version` and get an output like: `forge 0.2.0 (f016135 2022-07-04T00:15:02.930499Z)`

- To get the latest of each, just run `foundryup`

  

And you probably already have `make` installed... but if not [try looking here.](https://askubuntu.com/questions/161104/how-do-i-install-make)

  

## Quickstart

  

```sh

git clone https://github.com/owenwahlgren/evm-games-contracts.git

cd evm-games-contracts

make # installs the project's dependencies.

make test

```

  

## Testing

  

```

make test

```

  

or

  

```

forge test

```



  

## Setup

  

We'll demo using the Rinkeby testnet. (Go here for [testnet rinkeby ETH](https://faucets.chain.link/).)

  

You'll need to add the following variables to a `.env` file:

  

- `RINKEBY_RPC_URL`: An RPC URL to connect to the blockchain. You can get one for free from [Alchemy](https://www.alchemy.com/).

- `PRIVATE_KEY`: The private key of your wallet to deploy and interact with the contracts.

- Additionally, if you want to deploy to a testnet, you'll need test ETH and/or LINK. You can get them from [faucets.chain.link](https://faucets.chain.link/).

- Optional `ETHERSCAN_API_KEY`: If you want to verify on etherscan

  

## Deploying

  

```

make deploy-rinkeby contract=<CONTRACT_NAME>

```

  

For example:

  

```

make deploy-rinkeby contract=Jackpot

```

  

This will run the forge script, the script it's running is:

  

```

@forge script script/${contract}.s.sol:Deploy${contract} --rpc-url ${RINKEBY_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvv

```

  

If you don't have an `ETHERSCAN_API_KEY`, you can also just run:

  

```

@forge script script/${contract}.s.sol:Deploy${contract} --rpc-url ${RINKEBY_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast

```

  

These pull from the files in the `script` folder.

  

### Working with a local network

  

Foundry comes with local network [anvil](https://book.getfoundry.sh/anvil/index.html) baked in, and allows us to deploy to our local network for quick testing locally.

  

To start a local network run:

  

```

make anvil

```

  

This will spin up a local blockchain with a determined private key, so you can use the same private key each time.

  

Then, you can deploy to it with:

  

```

make deploy-anvil contract=<CONTRACT_NAME>

```

  

Similar to `deploy-rinkeby`

  

### Working with other chains

  

To add a chain, you'd just need to make a new entry in the `Makefile`, and replace `<YOUR_CHAIN>` with whatever your chain's information is.

  

```

deploy-<YOUR_CHAIN> :; @forge script script/${contract}.s.sol:Deploy${contract} --rpc-url ${<YOUR_CHAIN>_RPC_URL} --private-key ${PRIVATE_KEY} --broadcast -vvvv

  

```

  

# Security

  

This framework comes with slither parameters, a popular security framework from [Trail of Bits](https://www.trailofbits.com/). To use slither, you'll first need to [install python](https://www.python.org/downloads/) and [install slither](https://github.com/crytic/slither#how-to-install).

  

Then, you can run:

  

```

make slither

```

  

And get your slither output.

  
  
  

# Contributing

  
evm.games is currently being developed by a single contributor.
Dont be afraid to create a pull request, feedback and contributions are greatly appreciated!  

## Resources

- [EVM.GAMES](https://github.com/owenwahlgren/evm-games)

- [Chainlink Documentation](https://docs.chain.link/)

- [Foundry Documentation](https://book.getfoundry.sh/)

  

### TODO

|Contract|In Progress | Test Coverage |
|--|--|--|
| Jackpot | ✅ | 0%
| Coinflip | ❌ | 0%
| Blackjack | ❌ | 0%
| Connect Four| ❌ | 0%



  