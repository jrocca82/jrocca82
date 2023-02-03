// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../interfaces/IJoRocca.sol";

library TokenMetadata {
  using StringsUpgradeable for uint256;

  struct Attributes {
    string traitType;
    string value;
  }

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

  function formatAttributes(
    IJoRocca.Skill memory _skill,
    bool _addComma
  ) internal pure returns (bytes memory formattedAttribute) {
    formattedAttribute = abi.encodePacked(
      "{",
      formatJsonField("trait_type", _skill._skillName, true),
      formatJsonField("value", _skill._numberOfEndorsements.toString(), false),
      "}"
    );

    if (_addComma) {
      formattedAttribute = bytes.concat(
        formattedAttribute,
        abi.encodePacked(",")
      );
    }
  }

  function formatAttributesInMetadata(
    IJoRocca.Skill[] memory _skills
  ) internal pure returns (bytes memory attributes) {
    attributes = abi.encodePacked('"attributes": [');

    for (uint256 i = 0; i < _skills.length; i++) {
      bytes memory formattedType = formatAttributes(
        _skills[i],
        i != _skills.length - 1
      );

      attributes = bytes.concat(attributes, formattedType);
    }

    attributes = bytes.concat(attributes, "]");
  }

  function buildTokenURI(
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
      TokenMetadata.formatAttributesInMetadata(_skills),
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