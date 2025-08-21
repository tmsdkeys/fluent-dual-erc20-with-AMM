// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BasicAMM} from "../src/BasicAMM.sol";

contract Deploy is Script {
    // Deployment addresses
    address public tokenA;
    address public tokenB;
    address public basicAmm;
    
    function run() external {
        // Start broadcasting transactions
        vm.startBroadcast();
        
        // Step 1: Get token addresses from environment variables
        tokenA = vm.envAddress("SOLT_TOKEN_ADDRESS");
        tokenB = vm.envAddress("RUST_TOKEN_ADDRESS");
        
        console.log("Using Token A (SOLT) from env:", tokenA);
        console.log("Using Token B (RUST) from env:", tokenB);
        
        // Step 2: Deploy Basic AMM (pure Solidity baseline)
        basicAmm = address(new BasicAMM(
            tokenA,
            tokenB,
            "Basic AMM SOLTRUST LP Token",
            "SOLTRUST-LP"
        ));
        console.log("Basic AMM deployed at:", basicAmm);
        
        // Step 3: Save deployment addresses for testing
        saveDeploymentAddresses();
        
        vm.stopBroadcast();
        
        console.log("\n=== Deployment Complete ===");
        console.log("Token A:", tokenA);
        console.log("Token B:", tokenB);
        console.log("Basic AMM:", basicAmm);
    }
    
    function saveDeploymentAddresses() internal {
        // Save to a JSON file for easy access in tests
        string memory json = "deployment";
        vm.serializeAddress(json, "tokenA", tokenA);
        vm.serializeAddress(json, "tokenB", tokenB);
        string memory finalJson = vm.serializeAddress(json, "basicAMM", basicAmm);
        
        vm.writeJson(finalJson, "./deployments/testnet.json");
        console.log("Deployment addresses saved to deployments/testnet.json");
    }
}