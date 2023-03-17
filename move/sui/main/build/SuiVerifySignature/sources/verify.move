// https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/math/Move.toml
// https://github.com/MystenLabs/sui/tree/main/sui_programmability/examples/multi_package/dep_package
// good examples: https://docs.sui.io/explore/move-examples/basics
module sui_verify_signature::verify{

    // use 0x1::ed25519;
    // use 0x1::string;
    // use 0x1::bcs;
    // use std::hash;

    // use sui::object::{Self, UID};
    // use sui::transfer;
    // use sui::tx_context::{Self, TxContext};
    // use std::string::{Self, String};
    use std::debug;
    use sui::hash;
    // use sui::ecdsa_k1;
    use math::ecdsa_k1;

    


    // only one of these two makes sense -- or worse, they need to be unified to match the folder structure
    // use math_lib::ecdsa;
    // use math::ecdsa_k1;

    // struct SignedPrice has key, store {
    //     id: UID,
    //     oracle: vector<u8>,
    //     asset: vector<u8>,
    //     price: u128,
    //     timestamp: u128,
    //     signature: vector<u8>
    // }


    public fun gen_and_verify_signature(
        oracle_string: vector<u8>, // string::String, // vector<u8>
        asset_pair_id: vector<u8>, // string::String,
        price: vector<u8>, //u128,
        timestamp: vector<u8>, //u128,
        signature: vector<u8> // string::String,
    ) : bool {
  
        // step one: hash the message
        // step two: verify the signature

        debug::print(&oracle_string);
        // let oracle_string = bcs::to_bytes(&oracle_string);
        // let asset_pair_id = bcs::to_bytes(&asset_pair_id);
        // let sig_bytes = bcs::to_bytes(&signature);

        // TODO: can we just pass these things as a vector to begin with?
        // let price = bcs::to_bytes(&price);
        // let timestamp = bcs::to_bytes(&timestamp);


        // this transfers the data oject holding the address ot he recipient
        // i.e. we want to verify the address is real somehow
        // let new_message = hash::sha3_256(b"APTOS::RawTransaction");

        let pack = std::vector::empty<u8>(); // needs to be mut?
        let hi = b"hello";
        debug::print(&hi);
        debug::print(&oracle_string);
        
        std::vector::append(&mut pack, oracle_string);
        debug::print(&pack);
        std::vector::append(&mut pack, asset_pair_id);
        debug::print(&pack);
        std::vector::append(&mut pack, timestamp);
        debug::print(&pack);
        std::vector::append(&mut pack, price);

        // hash expects a byte vector so we should be fine here
        let new_message  = hash::keccak256(&pack); // or &oracle_string?

        let padder = b"\x19Ethereum Signed Message:\n32";

        let double_packed  = hash::keccak256(&padder);

        debug::print(&pack);
        debug::print(&new_message); // this is good actually!





        debug::print(&double_packed);

        // let response : vector<u8> = ecdsa_k1::erecover_to_eth_address_and_reply_2(signature, padder);
        let response : vector<u8> = ecdsa_k1::erecover_to_eth_address_and_reply(signature, padder);
        // ecdsa_k1::secp256k1_verify(&signature, &double_packed, &oracle_string)

        (response == oracle_string)
        

        // let bcs_hashed = hash::sha3_256(oracle_string);

        // std::vector::append(&mut new_message, bcs_hashed);

        // // let signature_vec = x"2f9b2ee794ae58cd1f7c362100e59cc0009966d94822d86fd4d5d83eddfb6d3382164f358bd8f70ee598f06eaa7d980a79921019415e5d60217ebbf2a0f7a902";
        // // let oracle_vec = x"f1a1a7a5706732b8026e5ccc5811b3392b3efbb6c7fa09e513b09f7bfe38edfd";

        // let sig = ed25519::new_signature_from_bytes(sig_bytes);
        // let public_key = ed25519::new_unvalidated_public_key_from_bytes(oracle_string);

        // return ed25519::signature_verify_strict(&sig, &public_key, new_message)

    }

    // todo: move to separate file
    #[test]
    public fun test_verify_addr() {

        // let oracle_string = b"0xf1a1a7a5706732b8026e5ccc5811b3392b3efbb6c7fa09e513b09f7bfe38edfd";
        // let asset_pair_id = b"ETHUSD";
        // let price: u128 = 1472980000000000000000;
        // let timestamp: u128 = 1663309101;
        // let signature = b"0x2f9b2ee794ae58cd1f7c362100e59cc0009966d94822d86fd4d5d83eddfb6d3382164f358bd8f70ee598f06eaa7d980a79921019415e5d60217ebbf2a0f7a902";

        /* {"0x51aa9e9c781f85a2c0636a835eb80114c4553098": {"external_asset_id": "XRPUSD", "price": "360500000000000000", 
         * "timestamped_signature": {"signature": {"r": "0x25a434cbece35d96bed07995de0689442cdf102d34b91e64e20362e00160ffd1", 
         * "s": "0x4007c7528fa2164e0ed95b6ae89716d2eb929ea02101f09eb7822a8a68c968a8", "v": "0x1b"}, "timestamp": "1678911180", 
         * "msg_hash": "0x5c505a54e938cf4030057f4d8e5817f34f126e807455d26b266373f331f76197"}}
         */
        let oracle_string = x"51aa9e9c781f85a2c0636a835eb80114c4553098";
        let asset_pair_id = b"XRPUSD";
        // let price: u128 = 360500000000000000;
        // let timestamp: u128 = 1678911180;
        // let price = x"0500c0d709874000"; // hex(timestamp) and prepend a 0
        let price = x"0000000000000000000000000000000000000000000000000500c0d709874000";
        // let timestamp = x"641226cc";
        let timestamp = x"00000000000000000000000000000000000000000000000000000000641226cc";
        let signature = b"0x25a434cbece35d96bed07995de0689442cdf102d34b91e64e20362e00160ffd14007c7528fa2164e0ed95b6ae89716d2eb929ea02101f09eb7822a8a68c968a81b";

        assert!(
             gen_and_verify_signature(oracle_string, asset_pair_id, price, timestamp, signature) == true, 0
        );
    }
    
}