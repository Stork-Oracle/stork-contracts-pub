import hashlib
import json
import os
import sys

from aptos_sdk import bcs
from aptos_sdk.account import Account
from aptos_sdk.bcs import Serializer

ser = Serializer()

# key pair was generated for testing purposes
PUBLIC_KEY = hex(int("b5e97db07fa0bd0e5598aa3643a9bc6f6693bddc1a9fec9e674a461eaa00b193", 16))
PRIVATE_KEY = hex(int("b5e97db07fa0bd0e5598aa3643a9bc6f6693bddc1a9fec9e674a461eaa00b193", 16))

NODE_URL = os.getenv("APTOS_NODE_URL", "https://fullnode.devnet.aptoslabs.com/v1")
FAUCET_URL = os.getenv(
    "APTOS_FAUCET_URL",
    "https://tap.devnet.prod.gcp.aptosdev.com",  # "https://faucet.testnet.aptoslabs.com"
)


if PUBLIC_KEY is None or PRIVATE_KEY is None:
    print("Set PUBLIC_KEY and PRIVATE_KEY env vars")
    sys.exit()


# signing_message = prefix_bytes | bcs_bytes_of_raw_transaction.
ASSET_PAIR = "ETHUSD"
TIMESTAMP = 1663309101
PRICE = 1472980000000000000000

# interface RawTransaction {
#   sender: AccountAddress;
#   sequence_number: number;
#   payload: ScriptFunction;
#   max_gas_amount: number;
#   gas_unit_price: number;
#   expiration_timestamp_secs: number;
#   chain_id: number;
# }


def generate_prefix_bytes():
    hash = hashlib.sha3_256()
    hash.update(b"APTOS::RawTransaction")
    # print(hash.digest())
    return hash.digest()


def bcs_serialize(PUBLIC_KEY, ASSET_PAIR, TIMESTAMP, PRICE):
    ser.str(PUBLIC_KEY)  # how to serialize this type?
    ser.str(ASSET_PAIR)
    ser.u128(TIMESTAMP)
    # print(ser.output())
    return ser.output()


def generate():
    acct = Account.generate()
    PRIVATE_KEY = hex(int(str(acct.private_key), 16))
    PUBLIC_KEY = hex(int(str(acct.public_key()), 16))
    prefix_bytes = generate_prefix_bytes()
    bcs_bytes = bcs_serialize(PUBLIC_KEY, ASSET_PAIR, TIMESTAMP, PRICE)
    concat_msg = prefix_bytes + bcs_bytes
    signature = acct.sign(concat_msg)

    print(
        json.dumps(
            {
                "oracle_name": PUBLIC_KEY,
                "asset_pair": ASSET_PAIR,
                "timestamp": TIMESTAMP,
                "price": PRICE,
                "msg_hash": "0x" + concat_msg.hex(),
                "signature": "0x" + signature.signature.hex(),
                # "r": hex(signed_msg_hash.r),
                # "s": hex(signed_msg_hash.s),
                # "v": hex(signed_msg_hash.v),
            },
            indent=4,
        )
    )


generate()
