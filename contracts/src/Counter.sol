// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract Token is Ownable {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    error InvalidSigner();
    error InvalidNonce(address user, uint nonce);

    mapping (address => uint) nonces;

    constructor(address initialOwner) Ownable(initialOwner) {}

    function claim(uint amount, uint nonce, bytes calldata signature) public {
      if (nonceOf(msg.sender) != nonce) revert InvalidNonce(msg.sender, nonce);
      if (keccak256(abi.encodePacked(msg.sender, amount, nonce))
        .toEthSignedMessageHash()
        .recover(signature) == owner()) {
          incrementNonceOf(msg.sender);
          // do the transfer....
        } else revert InvalidSigner();
    }

    function incrementNonceOf(address aUser) private {
      nonces[aUser] += 1;
    }

    function nonceOf(address aUser) public view returns (uint) {
      return nonces[aUser];
    }
}
