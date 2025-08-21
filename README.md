# ERC20 Interoperability Project

This project demonstrates ERC20 token interoperability between Solidity and Rust/WASM implementations on the Fluent blockchain. It showcases how both traditional Solidity smart contracts and modern WebAssembly-based contracts can coexist and interact within the same ecosystem.

## Project Overview

This repository contains a complete ERC20 token ecosystem with:

- **Solidity ERC20 Token** (`MyToken.sol`) - Traditional Solidity implementation using OpenZeppelin contracts
- **Rust/WASM ERC20 Token** (`rust-token/`) - Modern WebAssembly implementation using the FluentBase SDK
- **Deployment Scripts** - Automated deployment of both token types

## Project Structure

```
src/
├── MyToken.sol                   # Solidity ERC20 implementation
├── rust-token/                   # Rust/WASM ERC20 implementation
│   ├── Cargo.toml                # Rust dependencies and build config
│   └── src/lib.rs                # Rust ERC20 contract logic

script/
└── DeployTokens.s.sol            # Deployment script for both tokens

test/                             # Forge test suite
```

## Deployed Contracts

> **View Live Contracts**: You can check out the deployed versions of these tokens on the [Fluent Testnet Explorer](https://testnet.fluentscan.xyz) using the contract addresses below.

The deployment script will output the addresses of both deployed tokens:

- **RustyToken (RUST)**: [0x3785F7f6046f4401b6a7cC94397ecb42A26C7fD5](https://testnet.fluentscan.xyz/address/0x3785F7f6046f4401b6a7cC94397ecb42A26C7fD5)
- **SolToken (SOLT)**: [0xa37f1A5eedfb1D4e81AbE78c4B4b28c91744D1ab](https://testnet.fluentscan.xyz/address/0xa37f1A5eedfb1D4e81AbE78c4B4b28c91744D1ab)

## Features

### Solidity Token (MyToken.sol)

- Standard ERC20 functionality (transfer, approve, transferFrom)
- OpenZeppelin-based implementation with Ownable access control
- Minting and burning capabilities for token owners
- Configurable name, symbol, and initial supply

### Rust/WASM Token (rust-token)

- Full ERC20 compliance implemented in Rust
- Compiled to WebAssembly for blockchain execution
- Uses FluentBase SDK for blockchain integration
- Optimized for gas efficiency and performance
- Fixed supply of 1,000,000 tokens with 18 decimals

## Prerequisites

- [Foundry](https://getfoundry.sh/) - For Solidity development and testing
- [Rust](https://rustup.rs/) - For WASM contract development
- [Fluent CLI (gblend)](https://docs.fluent.xyz/gblend/installation) - For deployment and interaction

## Installation

1. Clone the repository:
```bash
git clone https://github.com/tmsdkeys/fluent-dual-erc20.git
cd fluent-dual-erc20
```

2. Install Foundry dependencies:
```bash
forge install
```

## Usage

### Building

Build both Solidity and WASM contracts:
```bash
# Will compile all Solidity and WASM contracts in src/ (including nested)
gblend build
```

> Note: You'll need Docker daemon running for this!

### Deployment

#### Deploy Both Tokens (Recommended)

```bash
gblend script script/DeployTokens.s.sol \
    --rpc-url https://rpc.testnet.fluent.xyz \
    --private-key $PRIVATE_KEY \
    --broadcast
```

#### Deploy Individual Tokens

**Deploy Rust/WASM Token:**

```bash
gblend create RustToken.wasm \
    --rpc-url https://rpc.testnet.fluent.xyz \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --wasm \
    --verifier blockscout \
    --verifier-url https://testnet.fluentscan.xyz/api/
```

**Deploy Solidity Token:**

```bash
gblend create src/MyToken.sol:MyToken \
    --rpc-url https://rpc.testnet.fluent.xyz \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --constructor-args $(cast abi-encode "constructor(string,string,uint256,address)" "SolToken" "SOLT" 5000000 $MY_ADDRESS)
```

### Verification

**Verify Rust/WASM Token:**

```bash
gblend verify-contract $RUST_TOKEN_ADDRESS RustToken.wasm \
    --wasm \
    --verifier blockscout \
    --verifier-url https://testnet.fluentscan.xyz/api/
```

**Verify Solidity Token:**

```bash
gblend verify-contract $SOLT_TOKEN_ADDRESS src/MyToken.sol:MyToken \
    --verifier blockscout \
    --verifier-url https://testnet.fluentscan.xyz/api/ \
    --constructor-args $(cast abi-encode "constructor(string,string,uint256,address)" "SolToken" "SOLT" 5000000 $MY_ADDRESS)
```

## Environment Variables

Set the following environment variables before deployment:

```bash
export PRIVATE_KEY="your_private_key_here"
export MY_ADDRESS="your_wallet_address_here"
```

## Development

### Adding New Token Types

1. Create a new token implementation in the appropriate language
2. Add deployment logic to `DeployTokens.s.sol`
3. Update tests to cover the new functionality

*Note: Token factory infrastructure for automated token creation is planned for future releases.*

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources

- [Fluent Documentation](https://docs.fluent.xyz/)
- [Foundry Book](https://getfoundry.sh/forge/overview)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Rust Book](https://doc.rust-lang.org/book/)
- [WebAssembly](https://webassembly.org/)
