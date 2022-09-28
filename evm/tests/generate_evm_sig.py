import json
import os
import sys
from eth_utils import keccak
from eth_abi.packed import encode_abi_packed
from eth_account.messages import encode_defunct
from web3.auto import w3

# key pair was generated for testing purposes
PUBLIC_KEY = os.environ.get("PUBLIC_KEY")
PRIVATE_KEY = os.environ.get("PRIVATE_KEY")

if PUBLIC_KEY is None or PRIVATE_KEY is None:
    print("Set PUBLIC_KEY and PRIVATE_KEY env vars")
    sys.exit()

ASSET_PAIR = "ETHUSD"
TIMESTAMP = 1663309101
PRICE = 1472980000000000000000

def evm_pack_hex(oracle_pubkey: str, asset_pair: str, timestamp: int, price: int):
    concat_hash = keccak(encode_abi_packed(['address','string','uint256','uint256'], [oracle_pubkey, asset_pair, timestamp, price]))
    return encode_defunct(concat_hash)

def sign(evm_packed_hash):
    signed_evm_message = w3.eth.account.sign_message(evm_packed_hash, private_key=PRIVATE_KEY)
    return signed_evm_message

msg_hash = evm_pack_hex(PUBLIC_KEY, ASSET_PAIR, TIMESTAMP, PRICE)
signed_msg_hash = sign(msg_hash)

print(json.dumps({
    "oracle_name": PUBLIC_KEY,
    "asset_pair": ASSET_PAIR,
    "timestamp": TIMESTAMP,
    "price": PRICE,
    "msg_hash": '0x' + msg_hash.body.hex(),
    "signature" : signed_msg_hash.signature.hex(),
    "r": hex(signed_msg_hash.r),
    "s": hex(signed_msg_hash.s),
    "v": hex(signed_msg_hash.v),
}, indent=4))
