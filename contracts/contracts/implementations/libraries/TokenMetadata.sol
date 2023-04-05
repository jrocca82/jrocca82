// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";

library TokenMetadata {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;

    function formatJsonField(
        string memory _fieldName,
        string memory _value,
        bool _addComma
    ) internal pure returns (bytes memory formattedJsonField) {
        formattedJsonField = abi.encodePacked(
            '"',
            _fieldName,
            '": ',
            '"',
            _value,
            '"'
        );

        if (_addComma) {
            formattedJsonField = bytes.concat(
                formattedJsonField,
                abi.encodePacked(",")
            );
        }
    }

    function formatEducationAttributes(
        IJoRocca.Education memory _education,
        bool _addComma
    ) internal pure returns (bytes memory formattedAttribute) {
        formattedAttribute = abi.encodePacked(
            "{",
            formatJsonField("university", _education._universityName, true),
            formatJsonField("degree", _education._degreeAwarded, false),
            "}"
        );

        if (_addComma) {
            formattedAttribute = bytes.concat(
                formattedAttribute,
                abi.encodePacked(",")
            );
        }
    }

    function formatSkillAttributes(
        IJoRocca.Skill memory _skill,
        bool _addComma
    ) internal pure returns (bytes memory formattedAttribute) {
        formattedAttribute = abi.encodePacked(
            "{",
            formatJsonField("skill", _skill._skillName, true),
            formatJsonField(
                "endorsements",
                _skill._numberOfEndorsements.toString(),
                true
            ),
            ' "endorsed_by": {'
        );
        for (uint256 i = 0; i < _skill._references.length; i++) {
            bytes memory formattedReference = formatJsonField(
                (i + 1).toString(),
                _skill._references[i].toHexString(),
                i != _skill._references.length - 1
            );

            formattedAttribute = bytes.concat(
                formattedAttribute,
                formattedReference
            );
        }

        formattedAttribute = bytes.concat(formattedAttribute, "}}");

        if (_addComma) {
            formattedAttribute = bytes.concat(
                formattedAttribute,
                abi.encodePacked(",")
            );
        }
    }

    function formatAttributesInMetadata(
        IJoRocca.Education[] memory _education,
        IJoRocca.Skill[] memory _skills
    ) internal pure returns (bytes memory attributes) {
        attributes = abi.encodePacked('"attributes": { "education": [');

        for (uint256 i = 0; i < _education.length; i++) {
            bytes memory formattedType = formatEducationAttributes(
                _education[i],
                i != _education.length - 1
            );

            attributes = bytes.concat(attributes, formattedType);
        }

        attributes = bytes.concat(attributes, '], "skills": [');

        for (uint256 i = 0; i < _skills.length; i++) {
            bytes memory formattedType = formatSkillAttributes(
                _skills[i],
                i != _skills.length - 1
            );

            attributes = bytes.concat(attributes, formattedType);
        }

        attributes = bytes.concat(attributes, "]}");
    }

    function buildTokenURI(
        IJoRocca.Education[] memory _education,
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
            TokenMetadata.formatJsonField("image", _imageURI, true),
            TokenMetadata.formatJsonField("description", _description, true),
            TokenMetadata.formatAttributesInMetadata(_education, _skills),
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
