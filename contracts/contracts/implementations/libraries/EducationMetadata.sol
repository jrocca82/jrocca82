// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";
import "./JsonEncode.sol";

library EducationMetadata {
    function formatEducationAttributes(
        IJoRocca.Education memory _education,
        bool _addComma
    ) internal pure returns (bytes memory formattedAttribute) {
        formattedAttribute = abi.encodePacked(
            "{",
            JsonEncode.formatJsonField("university", _education._universityName, true),
            JsonEncode.formatJsonField("degree", _education._degreeAwarded, false),
            "}"
        );

        if (_addComma) {
            formattedAttribute = bytes.concat(
                formattedAttribute,
                abi.encodePacked(",")
            );
        }
    }
}
