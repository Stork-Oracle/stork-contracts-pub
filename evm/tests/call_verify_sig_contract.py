from web3 import Web3
import os
import sys

CONTRACT_ADDRESS = os.environ.get("VERIFY_CONTRACT_ADDRESS", "0x73d7E67F39a4f0831292e90aBA925d70E3432b28")
GOERLI_PROVIDER = os.environ.get("GOERLI_PROVIDER")

if GOERLI_PROVIDER is None:
	print("Set GOERLI_PROVIDER env var")
	sys.exit()

ORACLE_PUBKEY = "0xcBCeF093430bBc560f994e5A14DB0dd727D03411"
ASSET_PAIR = "ETHUSD"
TIMESTAMP = 1663309101
PRICE = 1472980000000000000000
R = "0x2ec2a2da5a68aa2e5b6eb30723d8cf6d3f97f115dac50c5178360ee0ebaeba82"
S = "0x201726d52086a142834a65ebeedc3843724f527870616ae21e952958cc7ad296"
V = 0x1b

# abi copied from remix compiler/deployer
abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "oracle_pubkey",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "asset_pair_id",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			},
			{
				"internalType": "bytes32",
				"name": "r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "s",
				"type": "bytes32"
			},
			{
				"internalType": "uint8",
				"name": "v",
				"type": "uint8"
			}
		],
		"name": "verifySignature",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	}
]

w3 = Web3(Web3.HTTPProvider(GOERLI_PROVIDER))
contract = w3.eth.contract(CONTRACT_ADDRESS, abi=abi)

print("Contract: " + CONTRACT_ADDRESS)
print("Functions:")
[print("\t" + str(f)) for f in contract.all_functions()]

# print("Calling getMessageHash on contract " + CONTRACT_ADDRESS)
# msg_hash = contract.functions.getMessageHash(ORACLE_PUBKEY, ASSET_PAIR, TIMESTAMP, PRICE).call()
# print("\tmsg_hash: 0x" + msg_hash.hex())

print("Calling verifySignature on contract " + CONTRACT_ADDRESS)
response = contract.functions.verifySignature(ORACLE_PUBKEY, ASSET_PAIR, TIMESTAMP, PRICE, R, S, V).call()
print("\tresponse: " + str(response))
