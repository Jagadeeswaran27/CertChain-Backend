const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract with address:", deployer.address);

  const Certificate = await ethers.getContractFactory("CertificateNFT");
  const certificate = await Certificate.deploy();
  await certificate.deployed();

  console.log("Certificate contract deployed to:", certificate.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
