from web3 import Web3
import os

TEST_CONTRACT_ADDRESS = "0x1e4c45d7e64E22FDFB8955D5E93f5efad7aB83bc"
VERIFY_CONTRACT_ADDRESS = os.environ.get("VERIFY_CONTRACT_ADDRESS", "0x73d7E67F39a4f0831292e90aBA925d70E3432b28")

GOERLI_PROVIDER = os.environ.get("GOERLI_PROVIDER")

# abi copied from remix compiler/deployer
abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "a",
				"type": "address"
			}
		],
		"name": "callVerifySignature",
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
contract = w3.eth.contract(TEST_CONTRACT_ADDRESS, abi=abi)

print("Test Contract: " + TEST_CONTRACT_ADDRESS)
print("Functions:")
[print("\t" + str(f)) for f in contract.all_functions()]

print("Calling test on contract " + TEST_CONTRACT_ADDRESS)
response = contract.functions.callVerifySignature(VERIFY_CONTRACT_ADDRESS).call()
print("\tresponse: " + str(response))
