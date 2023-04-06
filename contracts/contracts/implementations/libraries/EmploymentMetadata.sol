// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";
import "./JsonEncode.sol";

library EmploymentMetadata {
    using StringsUpgradeable for uint256;

    function formatEmploymentAttributes(
        IJoRocca.Employment memory _employment,
        bool _addComma
    ) internal pure returns (bytes memory formattedAttribute) {
        string memory currentlyEmployed;
        if(_employment._current == true) {
            currentlyEmployed = "true";
        } else {
            currentlyEmployed = "false";
        }

        formattedAttribute = abi.encodePacked(
            "{",
            JsonEncode.formatJsonField(
                "employer_name",
                _employment._employerName,
                true
            ),
            JsonEncode.formatJsonField(
                "job_title",
                _employment._jobTitle,
                true
            ),
            JsonEncode.formatJsonField(
                "years_employed",
                _employment._noOfYears.toString(),
                true
            ),
            JsonEncode.formatJsonField(
                "currently_employed_here",
                currentlyEmployed,
                false
            ),
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
