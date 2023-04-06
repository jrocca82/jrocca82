// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";

library JsonEncode {
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
}
