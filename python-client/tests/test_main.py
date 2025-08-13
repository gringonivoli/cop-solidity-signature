"""Tests for main module."""

from web3 import Web3, Account
from eth_account.messages import encode_defunct
from src.env import user_private_key, owner_private_key

web3lib = Web3()
an_amount = 1
a_nonce = 0
user_wallet = Account.from_key(user_private_key())
owner_wallet = Account.from_key(owner_private_key())


def hash_of(an_address, an_amount, a_nonce):
    return web3lib.solidity_keccak(
        ["address", "uint256", "uint256"], [an_address, an_amount, a_nonce]
    ).hex()


def test_hash():
    assert (
        f"0x{hash_of(user_wallet.address, an_amount, a_nonce)}"
        == "0x75ca50b4c42ed7acf175082fdb327f998983a6f92f9e4cc4e555fb30f6fbc1bd"
    )


def test_signature():
    hash = web3lib.solidity_keccak(
        ["address", "uint256", "uint256"], [user_wallet.address, an_amount, a_nonce]
    )

    message = encode_defunct(hash)
    signed_message = web3lib.eth.account.sign_message(
        message, private_key=owner_wallet.key
    )

    assert (
        f"0x{signed_message.signature.hex()}"
        == "0x5cff4b47ae35b24fdabe84436e6c3a6ea2e3af178a3c73c31cbf7800d80d548f2fe6c7aaf09068904165ca40467c6551dae21b59e478bf5fb55cf74713d1cd601b"
    )
