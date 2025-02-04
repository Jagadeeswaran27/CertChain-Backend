// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Certificate {
    struct CertificateData {
        string recipientPublicKey;
        string issuer;
        string certificateHash;
        string documentUrl;
        uint256 issueDate;
    }

    mapping(string => CertificateData) public certificates;

    function issueCertificate(
        string memory _recipientPublicKey,
        string memory _issuer,
        string memory _certificateHash,
        string memory _documentUrl,
        uint256 _issueDate
    ) public {
        certificates[_certificateHash] = CertificateData(
            _recipientPublicKey,
            _issuer,
            _certificateHash,
            _documentUrl,
            _issueDate
        );
    }

    function verifyCertificate(
        string memory _certificateHash,
        string memory _recipientPublicKey
    ) public view returns (string memory) {
        require(
            keccak256(
                abi.encodePacked(
                    certificates[_certificateHash].recipientPublicKey
                )
            ) == keccak256(abi.encodePacked(_recipientPublicKey)),
            "Invalid recipient public key"
        );
        return certificates[_certificateHash].documentUrl;
    }
}
