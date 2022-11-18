#[test_only]
module VerifySigAddr::verify_tests {
  use VerifySigAddr::Verify;
  // use std::string;

  #[test]
  public entry fun verify_addr() {

    let oracle_pubkey = x"f1a1a7a5706732b8026e5ccc5811b3392b3efbb6c7fa09e513b09f7bfe38edfd";
    let signature= x"2f9b2ee794ae58cd1f7c362100e59cc0009966d94822d86fd4d5d83eddfb6d3382164f358bd8f70ee598f06eaa7d980a79921019415e5d60217ebbf2a0f7a902";
    // let message = x"b5e97db07fa0bd0e5598aa3643a9bc6f6693bddc1a9fec9e674a461eaa00b193746fac5ce76b85ceff208e93455d7788210ab4c4529c962adb0fbae7bbafb09d";
    // let asset_pair = string::utf8(b"ETHUSD")
    // let price = 
    // let timestamp: u128 = 

    assert!(
      Verify::verify_signature(oracle_pubkey, signature) == true, 0
    );
  }
}
