// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, Vm} from "forge-std/Test.sol";
import {Token} from "../src/Counter.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract CounterTest is Test {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    Token public token;
    Vm.Wallet public bob;
    Vm.Wallet public owner;
    Vm.Wallet public lisa;

    function setUp() public {
        owner = vm.createWallet("owner");
        bob = vm.createWallet("bob");
        lisa = vm.createWallet("lisa");
        token = new Token(owner.addr);
    }
    
    function test_nonceOf() public view {
      assertEq(0, token.nonceOf(lisa.addr));
    }

    function test_ClaimInvalidSigner() public {
      uint amount = 2;
      uint nonce = 0;

      bytes memory signature = _offChainBadSignature(bob.addr, amount, nonce);
      vm.expectRevert(Token.InvalidSigner.selector);

      vm.startPrank(bob.addr);
      token.claim(amount, nonce, signature);
      vm.stopPrank();
    }

    function test_ClaimInvalidNonce() public {
      uint amount = 2;
      uint nonce = 1;

      bytes memory signature = _offChainSignature(bob.addr, amount, nonce);

      vm.expectRevert(
        abi.encodeWithSelector(Token.InvalidNonce.selector, bob.addr, 1)
      );

      vm.startPrank(bob.addr);
      token.claim(amount, nonce, signature);
      vm.stopPrank();
    }

    function test_ClaimOk() public {
      uint amount = 2;
      uint nonce = 0;

      bytes memory signature = _offChainSignature(bob.addr, amount, nonce);

      vm.startPrank(bob.addr);
      token.claim(amount, nonce, signature);
      vm.stopPrank();

      assertEq(token.nonceOf(bob.addr), 1);
    }
    
    function _offChainBadSignature(address aUser, uint amount, uint nonce) private returns (bytes memory) {
      return _signature(aUser, amount, nonce, lisa);
    }

    function _offChainSignature(address aUser, uint amount, uint nonce) private returns (bytes memory) {
      return _signature(aUser, amount, nonce, owner);
    }

    function _signature(address aUser, uint amount, uint nonce, Vm.Wallet memory signer) private returns (bytes memory) {
      (uint8 v, bytes32 r, bytes32 s) = vm.sign(
        signer, 
        keccak256(abi.encodePacked(aUser, amount, nonce)).toEthSignedMessageHash()
      );
      return abi.encodePacked(r, s, v);
    }
}

