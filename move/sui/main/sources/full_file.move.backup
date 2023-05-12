// https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/math/Move.toml
// https://github.com/MystenLabs/sui/tree/main/sui_programmability/examples/multi_package/dep_package
// good examples: https://docs.sui.io/explore/move-examples/basics
module sui_verify_signature::verify{

    // use std::debug;
    use sui::hash;
    use std::bcs;
    use sui::event;
    use sui::ecdsa_k1;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;
    use std::vector;
    use std::debug;

    struct VerifiedEvent has copy, drop {
        is_verified: bool,
    }

    struct MyEvent has copy, drop {
        value: vector<u8>
    }

    /*
     * This this function accepts the components of a signature, as well as the signature, and verifies that the signature is valid.
     */
    public fun gen_and_verify_signature(
        oracle_string: vector<u8>, 
        asset_pair_id: vector<u8>, 
        price: vector<u8>, 
        timestamp: vector<u8>, 
        signature: vector<u8>,
    ) : bool {

        
        // Build the message from the components
        let pack = std::vector::empty<u8>(); 
        std::vector::append(&mut pack, oracle_string);
        std::vector::append(&mut pack, asset_pair_id);
        std::vector::append(&mut pack, timestamp);
        std::vector::append(&mut pack, price);

        // Hash the message
        let new_message  = hash::keccak256(&pack); // or &oracle_string?

        // Prepend the message with the Ethereum Signed Message prefix
        let padder = b"\x19Ethereum Signed Message:\n32";

        // Combine the message and the prefix
        std::vector::append(&mut padder, new_message);
        debug::print(&padder);
        let double_packed  = hash::keccak256(&padder); // this used to be useful when the old API required us to pre-hash the message
        debug::print(&double_packed);

        let response : vector<u8> = erecover_to_eth_address_and_reply(signature, padder);

        debug::print(&response); // keeping this here so we don't get complaints about debug::print not being used

        (response == oracle_string)

    }

    public entry fun verify_sig(
        oracle_string: vector<u8>, 
        asset_pair_id: vector<u8>, 
        price: u256, 
        timestamp: u256, 
        signature: vector<u8>,
        _garbage: vector<u8>
    ) {


        // Build the message from the components
        let pack = std::vector::empty<u8>(); 
        std::vector::append(&mut pack, oracle_string);
        std::vector::append(&mut pack, asset_pair_id);
        std::vector::append(&mut pack, pack_u256(timestamp));
        std::vector::append(&mut pack, pack_u256(price));

        // Hash the message
        let new_message  = hash::keccak256(&pack); // or &oracle_string?

        // Prepend the message with the Ethereum Signed Message prefix
        let padder = b"\x19Ethereum Signed Message:\n32";

        // Combine the message and the prefix
        std::vector::append(&mut padder, new_message);
        // let double_packed  = hash::keccak256(&padder); // this used to be useful when the old API required us to pre-hash the message



        // VLAD
        let response1 : vector<u8> = erecover_to_eth_address_and_reply(signature, padder);
        // let response1 : vector<u8> = erecover_to_eth_address_and_reply(signature, garbage);

        let response : bool = response1 == oracle_string;
        // VLAD

        // let response : bool = is_it_valid(signature, padder, signature);


        event::emit(VerifiedEvent {is_verified: response});
        // event::emit(MyEvent {value: double_packed});
        event::emit(MyEvent {value: new_message});


        // debug::print(&response); // keeping this here so we don't get complaints about debug::print not being used

    }

    // todo: move to separate file
    #[test]
    public fun test_verify_addr() {
        /* {"0x51aa9e9c781f85a2c0636a835eb80114c4553098": {"external_asset_id": "XRPUSD", "price": "360500000000000000", 
         * "timestamped_signature": {"signature": {"r": "0x25a434cbece35d96bed07995de0689442cdf102d34b91e64e20362e00160ffd1", 
         * "s": "0x4007c7528fa2164e0ed95b6ae89716d2eb929ea02101f09eb7822a8a68c968a8", "v": "0x1b"}, "timestamp": "1678911180", 
         * "msg_hash": "0x5c505a54e938cf4030057f4d8e5817f34f126e807455d26b266373f331f76197"}}
         */

         /*
          * Note that we use ABI.encodePacked in the Python script -- the `packed` means it adds the 0s 
          * ... so the length matches the length of the data type, which impacts the uints (price and timestamp)
          * Here I manually pad it, and I guess a user could do the same, but ideally we'll pad it in-code.
          * I also manually converted price and timestamp to hex from int in python, since I wasn't sure how to pad it properly.
          */
        let oracle_string = x"51aa9e9c781f85a2c0636a835eb80114c4553098";
        let asset_pair_id = b"XRPUSD";
        let price = (360500000000000000 as u256);
        let timestamp = (1678911180 as u256);
        let signature = x"25a434cbece35d96bed07995de0689442cdf102d34b91e64e20362e00160ffd14007c7528fa2164e0ed95b6ae89716d2eb929ea02101f09eb7822a8a68c968a81b";


        let price_in_bytes = pack_u256(price);
        let timestamp_in_bytes = pack_u256(timestamp);

        assert!(
             gen_and_verify_signature(oracle_string, asset_pair_id, price_in_bytes, timestamp_in_bytes, signature) == true, 0
        );
    }

    fun pack_u256(value_to_pack: u256) : vector<u8> {
        let value_vector = bcs::to_bytes(&value_to_pack);
        std::vector::reverse(&mut value_vector);
        value_vector
    }

    /* 
     * Library Starts Here
     */

    /// Object that holds the output data
    struct Output has key, store {
        id: UID,
        value: vector<u8>
    }

    public entry fun keccak256(data: vector<u8>, recipient: address, ctx: &mut TxContext) {
        let hashed = Output {
            id: object::new(ctx),
            value: hash::keccak256(&data),
        };
        // Transfer an output data object holding the hashed data to the recipient.
        transfer::transfer(hashed, recipient)
    }

    public fun is_it_valid(signature: vector<u8>, raw_msg: vector<u8>, sig: vector<u8>) : bool {
        let v = vector::borrow_mut(&mut signature, 64);
        if (*v == 27) {
            *v = 0;
        } else if (*v == 28) {
            *v = 1;
        } else if (*v > 35) {
            *v = (*v - 1) % 2;
        };

        let is_it_verified = ecdsa_k1::secp256k1_verify(&signature, &sig, &raw_msg, 0);
        (is_it_verified)
    }

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

     public entry fun verify_sig_impl(sig: vector<u8>, raw: vector<u8>, pub_key: vector<u8>) {
        // let sig = std::vector::empty<u8>();
        // let raw = std::vector::empty<u8>();
        let v = vector::borrow_mut(&mut sig, 64);
        if (*v == 27) {
            *v = 0;
        } else if (*v == 28) {
            *v = 1;
        } else if (*v > 35) {
            *v = (*v - 1) % 2;
        };

        // let pubkey = ecdsa_k1::secp256k1_ecrecover(&sig, &raw, 0);
        let pubkey = erecover_to_eth_address_and_reply(sig, raw);
        let x = pubkey == pub_key;
        event::emit(VerifiedEvent {is_verified: x});
    }
    
}