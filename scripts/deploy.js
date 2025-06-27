async function main() {
  const FanCredNFT = await ethers.getContractFactory("FanCredNFT");
  const fanCredNFT = await FanCredNFT.deploy();
  console.log("FanCredNFT deployed to:", fanCredNFT.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
