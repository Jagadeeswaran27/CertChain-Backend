// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CertificateNFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    struct CertificateData {
        string issuer;
        string certificateHash;
        uint256 issueDate;
    }

    mapping(uint256 => CertificateData) public certificateRecords;

    constructor() ERC721("CertificateNFT", "CERT") {}

    function issueCertificate(
        address recipient,
        string memory _issuer,
        string memory _certificateHash,
        string memory _fileUrl
    ) public returns (uint256) {
        uint256 newTokenId = _tokenIdCounter;
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, _fileUrl);

        certificateRecords[newTokenId] = CertificateData(
            _issuer,
            _certificateHash,
            block.timestamp
        );

        _tokenIdCounter++;
        return newTokenId;
    }

    function verifyCertificate(
        string memory _certificateHash,
        address recipient
    ) public view returns (string memory) {
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
                return tokenURI(tokenId);
            }
        }
        revert("Certificate not found for the given recipient");
    }
}
