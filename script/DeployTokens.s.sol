// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployRustToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
    
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy WASM RustToken
        bytes memory wasmBytecode = vm.getCode("out/RustToken.wasm/foundry.json");
        console.log("WASM bytecode size:", wasmBytecode.length);
        
        address rustToken;
        assembly {
            rustToken := create(0, add(wasmBytecode, 0x20), mload(wasmBytecode))
        }
        
        require(rustToken != address(0), "RustToken deployment failed");
        console.log("RustToken deployed at:", rustToken);
        
        console.log("Initializing Rust Token contract...");
        console.log("Contract Address (Rust Token):", rustToken);

        // Deploy Solidity ERC20 Token
        string memory name = "SolToken";
        string memory symbol = "SOLT";
        uint256 initialSupply = 5_000_000; // Will be scaled by 10**decimals() in constructor

        MyToken solToken = new MyToken(name, symbol, initialSupply, deployer);
        console.log("SolToken deployed at:", address(solToken));
        console.log("SolToken owner:", solToken.owner());
        console.log("SolToken totalSupply:", solToken.totalSupply());
        
        vm.stopBroadcast();
    }
}