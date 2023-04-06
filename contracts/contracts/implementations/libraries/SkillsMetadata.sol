// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";
import "./JsonEncode.sol";

library SkillsMetadata {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;

    function formatSkillAttributes(
        IJoRocca.Skill memory _skill,
        bool _addComma
    ) internal pure returns (bytes memory formattedAttribute) {
        formattedAttribute = abi.encodePacked(
            "{",
            JsonEncode.formatJsonField("skill", _skill._skillName, true),
            JsonEncode.formatJsonField(
                "endorsements",
                _skill._numberOfEndorsements.toString(),
                true
            ),
            ' "endorsed_by": {'
        );
        for (uint256 i = 0; i < _skill._references.length; i++) {
            bytes memory formattedReference = JsonEncode.formatJsonField(
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
}
