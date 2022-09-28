from web3 import Web3


TEST_CONTRACT_ADDRESS = "0x8b451C89afC76384Ed74Ad23b96fC46633857D5d"
VERIFY_CONTRACT_ADDRESS = "0x1e2922DcFc7922576Cc6DD68AD80CF345eaF15Ad"

# GOERLI_PROVIDER = "https://goerli.infura.io/v3/38aa092c1cb3430b8a9959bc8748c1ea"
GOERLI_PROVIDER = "https://eth-goerli.g.alchemy.com/v2/3H_XUX0C5kKBkizb0SJw0txtcdA2TSlK"

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
				"name": "verify_contract",
				"type": "address"
			},
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
		"name": "test",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
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
response = contract.functions.test(VERIFY_CONTRACT_ADDRESS, ORACLE_PUBKEY, ASSET_PAIR, TIMESTAMP, PRICE, R, S, V).call()
print("\tresponse: " + response)
