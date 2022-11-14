module verify_signature::Verify{
    use 0x1::Vector;
    use 0x1::Verify;
    use 0x1::Debug;
    use 0x1::secp256k1;

    use std::error;
    use std::signer;
    use std::string;
    use aptos_framework::account;
    use aptos_framework::event;
    
    public fun get_signed_message_hash32(vector<u8> message) vector<u8> {
        // https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/doc/secp256k1.md
        return ecdsa_signature_from_bytes(message): secp256k1::ECDSASignature // Possibly useful
        // return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
    }

    public fun get_message_hash(
        oracle_name: address,
        memory asset_pair_id: string::String, // No string type in move :(, meant to be vector
        timestamp: u128, // u128 is the biggest type, no 256
        price: u128,
    ) vector<u8> {
        // return keccak256(abi.encodePacked(oracle_name, asset_pair_id, timestamp, price));
    }

    public fun get_signer(
        signed_message_hash: vector<u8>,
        r: vector<u8>, // is bytes32 a vector?
        s: vector<u8>,
        v: u8
    ) address {
        // does signature need to be constructed to match the given type?
        return ecdsa_recover(signed_message_hash, recovery_id: u8, signature: &secp256k1::ECDSASignature)
    }


    public entry fun verify_signature(        
        oracle_pubkey: address,
        asset_pair_id: string::String, // No string type in move :(, meant to be vector
        timestamp: u128, // u128 is the biggest type, no 256
        price: u128,
        r: vector<u8>, // is bytes32 a vector?
        s: vector<u8>,
        v: u8
    ) : bool{

        vector<u8> msg_hash = get_message_hash(oracle_pubkey, asset_pair_id, timestamp, price);
        vector<u8> signed_message_hash = get_signed_message_hash32(msg_hash);

        // Verify hash was generated by the actual user
        address signer = get_signer(signed_message_hash, r, s, v);
        return (signer == oracle_pubkey) ? true : false

    }
    
}
