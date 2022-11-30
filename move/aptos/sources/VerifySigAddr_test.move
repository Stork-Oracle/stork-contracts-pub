#[test_only]
module VerifySigAddr::verify_tests {
  use VerifySigAddr::Verify;
  use 0x1::string;
  // use 0x1::bcs;

  #[test]
  public entry fun verify_addr() {

    let oracle_string = string::utf8(b"0xf1a1a7a5706732b8026e5ccc5811b3392b3efbb6c7fa09e513b09f7bfe38edfd");
    let asset_pair_id = string::utf8(b"ETHUSD");
    let price: u128 = 1472980000000000000000;
    let timestamp: u128 = 1663309101;
    let signature = string::utf8(b"0x2f9b2ee794ae58cd1f7c362100e59cc0009966d94822d86fd4d5d83eddfb6d3382164f358bd8f70ee598f06eaa7d980a79921019415e5d60217ebbf2a0f7a902");

    assert!(
      Verify::gen_and_verify_signature(oracle_string, asset_pair_id, price, timestamp, signature) == true, 0
    );
  }
}
