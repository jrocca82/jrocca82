// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";
import "./JsonEncode.sol";

library SocialsMetadata {
    function formatSocialMediaAttributes(
        IJoRocca.SocialMedia memory _socials,
        bool _addComma
    ) internal pure returns (bytes memory formattedAttribute) {
        formattedAttribute = abi.encodePacked(
            "{",
            JsonEncode.formatJsonField("platform", _socials._platform, true),
            JsonEncode.formatJsonField("link_or_username", _socials._linkOrUsername, false),
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
