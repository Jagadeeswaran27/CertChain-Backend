// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CertificateNFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    struct CertificateData {
        string issuer;
        string certificateHash;
        string certificateTitle;
        uint256 issueDate;
    }

    mapping(uint256 => CertificateData) public certificateRecords;

    constructor() ERC721("CertificateNFT", "CERT") {}

    function issueCertificate(
        address recipient,
        string memory _issuer,
        string memory _certificateHash,
        string memory _certificateTitle,
        string memory _fileUrl
    ) public returns (uint256) {
        uint256 newTokenId = _tokenIdCounter;

        certificateRecords[newTokenId] = CertificateData(
            _issuer,
            _certificateHash,
            _certificateTitle,
            block.timestamp
        );

        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, _fileUrl);

        _tokenIdCounter++;
        return newTokenId;
    }

    function verifyCertificate(
        string memory _certificateHash,
        address recipient
    ) public view returns (string memory tokenUri, string memory issuer) {
        for (uint256 tokenId = 0; tokenId < _tokenIdCounter; tokenId++) {
            if (
                keccak256(
                    abi.encodePacked(
                        certificateRecords[tokenId].certificateHash
                    )
                ) ==
                keccak256(abi.encodePacked(_certificateHash)) &&
                ownerOf(tokenId) == recipient
            ) {
                return (tokenURI(tokenId), certificateRecords[tokenId].issuer);
            }
        }
        revert("Certificate not found for the given recipient");
    }
}
