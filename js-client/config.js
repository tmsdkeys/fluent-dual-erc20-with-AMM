// Load environment variables from .env file
require("dotenv").config();

const ethers = require("ethers");
const fs = require("fs");
const path = require("path");

// Configuration
const CONFIG = {
  rpcURL: "https://rpc.testnet.fluent.xyz/",
  chainId: 20994, // Fluent testnet

  // Load from deployments/testnet.json
  addresses: {
    tokenA: "0xa37f1A5eedfb1D4e81AbE78c4B4b28c91744D1ab",
    tokenB: "0x3785F7f6046f4401b6a7cC94397ecb42A26C7fD5",
    basicAMM: "0x8ff396af8BdEF1d23d7a7363CFc81Ed604eeB399",
  },

  // Test amounts
  INITIAL_LIQUIDITY: ethers.utils.parseEther("1000"), // 1k tokens (reduced from 10k)
  SWAP_AMOUNT: ethers.utils.parseEther("100"), // 100 tokens
  TEST_TOKENS_PER_USER: ethers.utils.parseEther("5000"), // 5k tokens per user

  // Your private key (set this as environment variable)
  privateKey: "",
};

// Helper function to load ABI from build artifacts
function loadABI(contractName) {
  try {
    const artifactPath = path.join(
      __dirname,
      "..",
      "out",
      `${contractName}.sol`,
      `${contractName}.json`
    );
    const artifact = JSON.parse(fs.readFileSync(artifactPath, "utf8"));
    return artifact.abi;
  } catch (error) {
    console.warn(
      `Warning: Could not load ABI for ${contractName}: ${error.message}`
    );
    return [];
  }
}

// Create provider
const provider = new ethers.providers.JsonRpcProvider(CONFIG.rpcURL);

// Create wallet
const wallet = new ethers.Wallet(CONFIG.privateKey, provider);

// Load ABIs from build artifacts
const ERC20_ABI = loadABI("ERC20");
const BASIC_AMM_ABI = loadABI("BasicAMM");

// Helper functions
function formatEther(value) {
  return ethers.utils.formatEther(value);
}

function parseEther(value) {
  return ethers.utils.parseEther(value.toString());
}

async function getGasUsed(tx) {
  const receipt = await tx.wait();
  return receipt.gasUsed;
}

function calculateGasSavings(basicGas, enhancedGas) {
  if (basicGas.eq(0)) return "N/A";
  const diff = basicGas.sub(enhancedGas);
  const percentSaved = diff.mul(100).div(basicGas);
  return {
    saved: diff,
    percentSaved: percentSaved.toNumber(),
  };
}

module.exports = {
  CONFIG,
  provider,
  wallet,
  ERC20_ABI,
  BASIC_AMM_ABI,
  formatEther,
  parseEther,
  getGasUsed,
  calculateGasSavings,
};
