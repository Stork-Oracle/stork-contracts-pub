module sui_verify_signature::verify{
    use sui::hash;
    use std::bcs;
    use sui::event;
    use sui::ecdsa_k1;
    use std::vector;

    public entry fun verify_sig(
        oracle_string: vector<u8>, 
        asset_pair_id: vector<u8>, 
        price: u256, 
        timestamp: u256, 
        signature: vector<u8>
    ) {

        // Build the message from the components
        let pack = std::vector::empty<u8>(); 
        std::vector::append(&mut pack, oracle_string);
        std::vector::append(&mut pack, asset_pair_id);
        std::vector::append(&mut pack, pack_u256(timestamp));
        std::vector::append(&mut pack, pack_u256(price));

        // Hash the message
        let hashed_message  = hash::keccak256(&pack); 

        // Prepend the message with the Ethereum Signed Message prefix
        let padder = b"\x19Ethereum Signed Message:\n32";

        // Combine the message and the prefix
        std::vector::append(&mut padder, hashed_message);

        let response : bool = erecover_to_eth_address_and_reply(signature, padder) == oracle_string;
        event::emit(VerifiedEvent {is_verified: response});

    }

    /* 
     * Library Methods
     */

    struct VerifiedEvent has copy, drop {
        is_verified: bool,
    }

    struct MyEvent has copy, drop {
        value: vector<u8>
    }

    fun pack_u256(value_to_pack: u256) : vector<u8> {
        let value_vector = bcs::to_bytes(&value_to_pack);
        std::vector::reverse(&mut value_vector);
        value_vector
    }

    // Recovers and returns the signing address
    public fun erecover_to_eth_address_and_reply(signature: vector<u8>, raw_msg: vector<u8>) : vector<u8> {
        let v = vector::borrow_mut(&mut signature, 64);
        if (*v == 27) {
            *v = 0;
        } else if (*v == 28) {
            *v = 1;
        } else if (*v > 35) {
            *v = (*v - 1) % 2;
        };

        let pubkey = ecdsa_k1::secp256k1_ecrecover(&signature, &raw_msg, 0);
        let uncompressed = ecdsa_k1::decompress_pubkey(&pubkey);


        // Take the last 64 bytes of the uncompressed pubkey.
        let uncompressed_64 = vector::empty<u8>();
        let i = 1;
        while (i < 65) {
            let value = vector::borrow(&uncompressed, i);
            vector::push_back(&mut uncompressed_64, *value);
            i = i + 1;
        };

        // Take the last 20 bytes of the hash of the 64-bytes uncompressed pubkey.
        let hashed = hash::keccak256(&uncompressed_64);
        let addr = vector::empty<u8>();
        let i = 12;
        while (i < 32) {
            let value = vector::borrow(&hashed, i);
            vector::push_back(&mut addr, *value);
            i = i + 1;
        };

        (addr)
    }
    
}