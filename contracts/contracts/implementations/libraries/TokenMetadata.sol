// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";
import "./ContactMetadata.sol";
import "./SocialsMetadata.sol";
import "./EducationMetadata.sol";
import "./EmploymentMetadata.sol";
import "./SkillsMetadata.sol";
import "./JsonEncode.sol";

library TokenMetadata {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;

    function formatAttributesInMetadata(
        IJoRocca.ContactInfo memory _contact,
        IJoRocca.SocialMedia[] memory _socials,
        IJoRocca.Education[] memory _education,
        IJoRocca.Employment[] memory _employment,
        IJoRocca.Skill[] memory _skills
    ) internal pure returns (bytes memory attributes) {
        attributes = abi.encodePacked('"attributes": { "contact": ');
        bytes memory formattedContact = ContactMetadata.formatContactAttributes(
            _contact,
            true
        );

        attributes = bytes.concat(attributes, formattedContact);

        attributes = bytes.concat(attributes, ' "social_media": [');

        for (uint256 i = 0; i < _socials.length; i++) {
            bytes memory formattedType = SocialsMetadata
                .formatSocialMediaAttributes(
                    _socials[i],
                    i != _socials.length - 1
                );

            attributes = bytes.concat(attributes, formattedType);
        }

        attributes = bytes.concat(attributes, '], "education": [');

        for (uint256 i = 0; i < _education.length; i++) {
            bytes memory formattedType = EducationMetadata
                .formatEducationAttributes(
                    _education[i],
                    i != _education.length - 1
                );

            attributes = bytes.concat(attributes, formattedType);
        }

        attributes = bytes.concat(attributes, '], "employment": [');

        for (uint256 i = 0; i < _employment.length; i++) {
            bytes memory formattedType = EmploymentMetadata
                .formatEmploymentAttributes(
                    _employment[i],
                    i != _employment.length - 1
                );

            attributes = bytes.concat(attributes, formattedType);
        }

        attributes = bytes.concat(attributes, '], "skills": [');

        for (uint256 i = 0; i < _skills.length; i++) {
            bytes memory formattedType = SkillsMetadata.formatSkillAttributes(
                _skills[i],
                i != _skills.length - 1
            );

            attributes = bytes.concat(attributes, formattedType);
        }

        attributes = bytes.concat(attributes, "]}");
    }

    function buildTokenURI(
        IJoRocca.ContactInfo memory _contact,
        IJoRocca.SocialMedia[] memory _socials,
        IJoRocca.Education[] memory _education,
        IJoRocca.Employment[] memory _employment,
        IJoRocca.Skill[] memory _skills,
        string memory _name,
        string memory _imageURI,
        string memory _description,
        uint256 _tokenId
    ) internal pure returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "',
            _name,
            " #",
            _tokenId.toString(),
            '",',
            JsonEncode.formatJsonField("image", _imageURI, true),
            JsonEncode.formatJsonField("description", _description, true),
            TokenMetadata.formatAttributesInMetadata(
                _contact,
                _socials,
                _education,
                _employment,
                _skills
            ),
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64Upgradeable.encode(dataURI)
                )
            );
    }
}
