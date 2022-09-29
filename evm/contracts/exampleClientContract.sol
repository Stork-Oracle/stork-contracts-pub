// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0 <0.9.0;

// interface to another deployed contract
contract Verify {
    function verifySignature(
        address oracle_pubkey,
        string memory asset_pair_id,
        uint256 timestamp,
        uint256 price,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) public pure returns (bool) {}
}

contract ClientContract {
    function callVerifySignature(address a) public pure returns (bool) {
        Verify verify = Verify(a);
        bool result = verify.verifySignature(
            0xcBCeF093430bBc560f994e5A14DB0dd727D03411,
            "ETHUSD",
            1663309101,
            1472980000000000000000,
            0x2ec2a2da5a68aa2e5b6eb30723d8cf6d3f97f115dac50c5178360ee0ebaeba82,
            0x201726d52086a142834a65ebeedc3843724f527870616ae21e952958cc7ad296,
            0x1b
        );
        return result;
    }
}
