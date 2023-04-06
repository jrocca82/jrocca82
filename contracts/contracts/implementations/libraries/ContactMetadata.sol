// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";
import "./JsonEncode.sol";

library ContactMetadata {
    function formatContactAttributes(
        IJoRocca.ContactInfo memory _contact,
        bool _addComma
    ) internal pure returns (bytes memory formattedAttribute) {
        formattedAttribute = abi.encodePacked(
            "{",
            JsonEncode.formatJsonField(
                "phone_number",
                _contact._phoneNumber,
                true
            ),
            JsonEncode.formatJsonField("email", _contact._email, true),
            JsonEncode.formatJsonField("location", _contact._location, false),
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
