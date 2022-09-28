# evm
EVM-related smart contracts

Currently Remix is used as the main dev environment and this repo serves as secondary storage.

# Keys
Sample site to generate eth public/private key pair for testing: https://vanity-eth.tk/

`PUBLIC_KEY` and `PRIVATE_KEY` env vars should be set in order to generate sample signatures using `tests/generate_evm_sig.py`.

# Usage
## Deployments
Contracts can be deployed to local VMs or Goerli testnet by copying the contract into the Remix IDE: https://remix.ethereum.org/

To make calls to a contract on Goerli, create an app key using either
- Alchemy (better visibility): https://www.alchemy.com/
- Infura: https://infura.io/

set the resulting URL as `GOERLI_PROVIDER` env var.

Get Goerli testnet ETH from Alchemy faucet (requires account).

## ABI
Currently ABI is copied from Remix compilation output.

Any changes to the contract functions will result in changes to the ABI, requiring changes to the tests.
