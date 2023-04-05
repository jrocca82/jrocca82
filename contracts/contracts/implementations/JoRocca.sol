// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "../interfaces/IJoRocca.sol";
import "./libraries/TokenMetadata.sol";

contract JoRocca is IJoRocca, Initializable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;

    // Token Information
    string private _name;
    string private _symbol;
    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;
    CountersUpgradeable.Counter private _tokenCounter;
    // Mapping owner address to token count
    mapping(address => uint256) private _balances;
    string public imageUri;

    // General Information
    string public description;
    ContactInfo public contactDetails;
    SocialMedia[] public socialMedia;

    // Employment
    Employment[] public employmentHistory;

    // Educational History
    Education[] public educationHistory;

    // Skills
    Skill[] public skills;

    function initialize(
        ContactInfo memory _contactInfo,
        string memory _tokenName,
        string memory _tokenSymbol,
        string memory _profileDescription,
        string memory _imageURI
    ) external initializer {
        __Ownable_init();
        _name = _tokenName;
        _symbol = _tokenSymbol;
        description = _profileDescription;
        contactDetails = _contactInfo;
        imageUri = _imageURI;
        _tokenCounter.increment();
    }

    function resetImageUri(string memory _newImageUri) public onlyOwner{
        imageUri = _newImageUri;
    }

    function updateDescription(string memory _newDescription) public onlyOwner {
        description = _newDescription;
    }

    function getEmploymentHistory() public view returns (Employment[] memory) {
        return employmentHistory;
    }

    function addEmployment(
        Employment memory _newEmploymentRecord
    ) public override onlyOwner {
        employmentHistory.push(_newEmploymentRecord);
    }

    function addEducation(
        Education memory _newEducationRecord
    ) public override onlyOwner {
        educationHistory.push(_newEducationRecord);
    }

    function addSocialMedia(
        string memory _platform,
        string memory _linkOrUsername
    ) public override onlyOwner {
        socialMedia.push() = SocialMedia({
            _platform: _platform,
            _linkOrUsername: _linkOrUsername
        });
    }

    function removeSocialMedia(uint256 _index) public override onlyOwner {
        SocialMedia memory lastItem = socialMedia[socialMedia.length - 1];
        socialMedia[_index] = lastItem;
        socialMedia.pop();
    }

    function addSkill(
        string memory _skillName
    ) public override onlyOwner {
        skills.push() = Skill({
            _skillName: _skillName,
            _numberOfEndorsements: 0,
            _references: new address[](0)
        });
    }

    function endorseSkill(string memory _skillName) public override {
        for (uint256 i = 0; i < skills.length; i++) {
            if (
                keccak256(abi.encodePacked(skills[i]._skillName)) ==
                keccak256(abi.encodePacked(_skillName))
            ) {
                skills[i]._numberOfEndorsements += 1;
                skills[i]._references.push(msg.sender);
            }
        }
    }

    function getAllSkills() public view returns (Skill[] memory) {
        return skills;
    }

    function getContactDetails()
        public
        view
        override
        returns (ContactInfo memory, SocialMedia[] memory)
    {
        return (contactDetails, socialMedia);
    }

    function updateContactDetails(
        ContactInfo memory _newContactDetails
    ) public onlyOwner {
        contactDetails = _newContactDetails;
    }

    // TOKEN FUNCTIONS
    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        return
            TokenMetadata.buildTokenURI(
                educationHistory,
                skills,
                _name,
                imageUri,
                description,
                _tokenId
            );
    }

    function mint(address to) external override onlyOwner {
        uint256 currentTokenId = _tokenCounter.current();

        // Update state variables
        _owners[currentTokenId] = to;
        _balances[to] += 1;

        // Increment for next call
        _tokenCounter.increment();
    }

    function balanceOf(
        address owner
    ) public view virtual override returns (uint256) {
        return _balances[owner];
    }

    function ownerOf(
        uint256 tokenId
    ) public view virtual override returns (address) {
        return _ownerOf(tokenId);
    }

    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(IERC165) returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
