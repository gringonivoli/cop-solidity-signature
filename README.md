# Token Claim System

A secure token claiming system with signature-based verification, featuring smart contracts and client implementations.

## Overview

This project implements a token claiming mechanism where users can claim tokens using off-chain signatures. The system uses nonces to prevent replay attacks and ECDSA signatures for authentication.

## Structure

- **`contracts/`** - Solidity smart contracts
  - Token contract with claim functionality
  - Foundry-based testing suite
  - OpenZeppelin dependencies

- **`python-client/`** - Python client implementation
  - Web3.py integration
  - Signature generation and verification

- **`typescript-client/`** - TypeScript client implementation
  - Node.js based client
  - Jest testing framework

## Key Features

- **Signature-based claiming** - Users claim tokens with off-chain signatures
- **Nonce management** - Prevents replay attacks
- **Multi-client support** - Python and TypeScript implementations
- **Comprehensive testing** - Foundry tests for contracts

## Requirements

- Node.js (for TypeScript client)
- Python 3.x (for Python client)
- Foundry (for smart contract development)

## Quick Start

1. Install dependencies for your chosen client
2. Configure environment variables (see `env.example` files)
3. Deploy contracts using Foundry
4. Run client to interact with contracts

## Security

- Uses ECDSA signatures for authentication
- Implements nonce-based replay protection
- Owner-only signature validation

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
