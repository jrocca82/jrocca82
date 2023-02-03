// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "../interfaces/IJoRocca.sol";

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

    // General Information
    string public description;
    ContactInfo public contactDetails;
    SocialMedia[] public socialMedia;

    // Employment
    Employment[] public employmentHistory;
    mapping(uint64 => Employment) public occupationByYear;

    // Educational History
    Education[] public educationHistory;
    mapping(uint64 => Education) public educationByYear;

    // Skills
    Skill[] public skills;
    mapping(string => uint64) public skillEndorsements;
    mapping(string => address[]) public skillReferences;
    mapping(string => Skill) public skillDetails;

    function initialize(ContactInfo memory _contactInfo) external initializer {
        __Ownable_init();
        contactDetails = _contactInfo;
    }

    function addEmployment(
        Employment memory _newEmploymentRecord
    ) public override onlyOwner {
        employmentHistory.push(_newEmploymentRecord);
        for (
            uint64 i = _newEmploymentRecord._startYear;
            i < _newEmploymentRecord._endYear;
            i++
        ) {
            occupationByYear[i] = _newEmploymentRecord;
        }
    }

    function addEducation(
        Education memory _newEducationRecord
    ) public override onlyOwner {
        educationHistory.push(_newEducationRecord);
        for (
            uint64 i = _newEducationRecord._startYear;
            i < _newEducationRecord._endYear;
            i++
        ) {
            educationByYear[i] = _newEducationRecord;
        }
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
        SocialMedia memory lastItem = socialMedia[
            socialMedia.length - 1
        ];
        socialMedia[_index] = lastItem;
        socialMedia.pop();
    }

    function addSkill(Skill memory _newSkill) public override onlyOwner {
        skills.push(_newSkill);
        skillDetails[_newSkill._skillName] = _newSkill;
    }

    function endorseSkill(string memory _skillName) public override {
        skillEndorsements[_skillName] += 1;
        skillReferences[_skillName].push(address(msg.sender));
    }

    function getContactDetails()
        public
        view
        override
        returns (ContactInfo memory, SocialMedia[] memory)
    {
        return (contactDetails, socialMedia);
    }

    function updateContactDetails(ContactInfo memory _newContactDetails) public onlyOwner {
        contactDetails = _newContactDetails;
    }

    // TOKEN FUNCTIONS
    function tokenURI() external view returns (string memory) {}

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
