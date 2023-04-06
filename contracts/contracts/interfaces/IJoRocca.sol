// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IJoRocca is IERC165 {
    struct ContactInfo {
        string _phoneNumber;
        string _email;
        string _location;
    }

    struct SocialMedia {
        string _platform;
        string _linkOrUsername;
    }

    struct Education {
        string _universityName;
        string _degreeAwarded;
    }

    struct Employment {
        string _employerName;
        string _jobTitle;
        uint256 _noOfYears;
        bool _current;
    }

    struct Skill {
        string _skillName;
        uint256 _numberOfEndorsements;
        address[] _references;
    }

    //###### EVENTS ######
    /// @dev This emits ONLY when token `_tokenId` is minted from the zero address and is used to conform closely to ERC721 standards
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    //###### ERRORS ######
    /// @dev HasToken error is thrown if the target wallet for minting already has a token
    error HasToken();

    //###### FUNCTIONS ######
    /// @dev Adds a new social media record (only contract owner)
    /// @param _socialMedia the social media struct
    function addSocialMedia(SocialMedia memory _socialMedia) external;

    /// @dev Removes a social media record (only contract owner)
    /// @param _id The social media record id to remove
    function removeSocialMedia(uint256 _id) external;

    /// @dev Adds a new record of employment (only contract owner)
    /// @param _newEmploymentRecord details of the new employment
    function addEmployment(Employment memory _newEmploymentRecord) external;

    /// @dev Adds a new education record (only contract owner)
    /// @param _newEducationRecord details of the new education record
    function addEducation(Education memory _newEducationRecord) external;

    /// @dev Adds a new skill (only contract owner)
    /// @param _skillName the name of the skill
    function addSkill(string memory _skillName) external;

    /// @dev Endorse a skill
    /// @param _skillName the skill to endorse. This skill must already have been added by the addSkill function
    function endorseSkill(string memory _skillName) external;

    /// @dev Returns the token URI, which contains the token metadata
    function tokenURI(uint256 _tokenId) external view returns (string memory);

    /// @notice mints a new resume token
    /// @param _to the address to send the token to
    function mint(address _to) external;

    function balanceOf(address owner) external view returns (uint256);

    function ownerOf(uint256 tokenId) external view returns (address);

    function getContactDetails()
        external
        view
        returns (ContactInfo calldata, SocialMedia[] calldata);
}
