const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Certificate", function () {
  let Certificate;
  let certificate;
  let owner;
  let addr1;

  beforeEach(async function () {
    Certificate = await ethers.getContractFactory("Certificate");
    [owner, addr1] = await ethers.getSigners();
    certificate = await Certificate.deploy();
    await certificate.deployed();
  });

  it("Should create and retrieve a certificate", async function () {
    const ipfsHash = "QmTzQ1N1Q1N1Q1N1Q1N1Q1N1Q1N1Q1N1Q1N1Q1N1Q1N1Q1N1";
    const fileHash = ethers.utils.keccak256(
      ethers.utils.toUtf8Bytes("certificate content")
    );

    const certificateId = await certificate.createCertificate(
      ipfsHash,
      fileHash,
      addr1.address
    );
    const certData = await certificate.getCertificate(certificateId);

    expect(certData[0]).to.equal(ipfsHash);
    expect(certData[1]).to.equal(fileHash);
    expect(certData[2]).to.equal(addr1.address);
  });

  it("Should fail to retrieve a non-existent certificate", async function () {
    const nonExistentCertificateId = ethers.utils.keccak256(
      ethers.utils.toUtf8Bytes("non-existent certificate")
    );
    await expect(
      certificate.getCertificate(nonExistentCertificateId)
    ).to.be.revertedWith("Certificate not found");
  });
});
