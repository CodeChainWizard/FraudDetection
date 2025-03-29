const hre = require("hardhat");

async function main() {
  console.log("Starting deployment...");

  const MultiChainWallet = await hre.ethers.getContractFactory(
    "MultiChainTransaction"
  );

  const multiChainWallet = await MultiChainWallet.deploy();

  await multiChainWallet.waitForDeployment();

  console.log(`MultiChainWallet deployed at: ${multiChainWallet.target}`);

  console.log("\nDeployment Completed Successfully!");
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});
