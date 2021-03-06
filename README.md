# Foundry Faucet

A simple project built using Foundry. This repo contains the implementation of a Faucet contract. You can find the article associated with this repo here.

> This repo is created from the [forge template](https://github.com/PraneshASP/forge-template).

## Getting Started

- Clone this repo:

```sh
git clone https://github.com/PraneshASP/foundry-faucet
```

- Install the dependencies/libraries:

```bash
git submodule update --init --recursive
forge install
```

## Directory structure

```ml
lib
├─ forge-std — https://github.com/brockelmore/forge-std
├─ openzeppelin-contracts — https://github.com/OpenZeppelin/openzeppelin-contracts
src
├─ tests
│  └─ Faucet.t.sol — "Test suite for the faucet"
├─ Facuet.sol — "A Simple Faucet contract implementation"
└─ MockERC20.sol — "A Mock ERC20 token for the faucet"

```

## Development

**Compilation**

```bash
forge build
```

**Testing**

```bash
forge test
```

To run tests with console outputs (`console.logs()`):

```bash
forge test -vv
```

**Deployment**

Copy the .`env.example` file to `.env` and update the values.

### Using `forge create`:

First, deploy the MockERC20 to Kovan:

```bash
./scripts/deploy_token_kovan.sh
```

Then, deploy the Faucet to Kovan:

```bash
./scripts/deploy_faucet_kovan.sh
```

### Using `scripts`:

```bash
npm run deploy:forge
```

**Verification**

Add your `ETHERSCAN_API_KEY` to the `.env` file.

Then execute the `scripts/verify_faucet_kovan.sh` script.

```sh
./scripts/verify_faucet_kovan.sh
```

## License

[MIT](https://github.com/PraneshASP/foundry-faucet/blob/master/LICENSE)

## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._
