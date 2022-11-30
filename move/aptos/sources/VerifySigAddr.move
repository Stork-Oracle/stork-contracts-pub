module VerifySigAddr::Verify{

    use 0x1::ed25519;
    use 0x1::string;
    use 0x1::bcs;
    use std::hash;

    public fun gen_and_verify_signature(
        oracle_string: string::String,
        asset_pair_id: string::String,
        price: u128,
        timestamp: u128,
        signature: string::String,
    ) : bool {
  
        let oracle_string = bcs::to_bytes(&oracle_string);
        let asset_pair_id = bcs::to_bytes(&asset_pair_id);
        let sig_bytes = bcs::to_bytes(&signature);
        let price = bcs::to_bytes(&price);
        let timestamp = bcs::to_bytes(&timestamp);

        let new_message = hash::sha3_256(b"APTOS::RawTransaction");

        std::vector::append(&mut oracle_string, asset_pair_id);
        std::vector::append(&mut oracle_string, timestamp);
        std::vector::append(&mut oracle_string, price);

        let bcs_hashed = hash::sha3_256(oracle_string);

        std::vector::append(&mut new_message, bcs_hashed);

        // let signature_vec = x"2f9b2ee794ae58cd1f7c362100e59cc0009966d94822d86fd4d5d83eddfb6d3382164f358bd8f70ee598f06eaa7d980a79921019415e5d60217ebbf2a0f7a902";
        // let oracle_vec = x"f1a1a7a5706732b8026e5ccc5811b3392b3efbb6c7fa09e513b09f7bfe38edfd";

        let sig = ed25519::new_signature_from_bytes(sig_bytes);
        let public_key = ed25519::new_unvalidated_public_key_from_bytes(oracle_string);

        return ed25519::signature_verify_strict(&sig, &public_key, new_message)

    }
    
}