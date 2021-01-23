// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

// Importing OpenZeppelin's SafeMath Implementation
import '@openzeppelin/contracts/math/SafeMath.sol';

import './Utils.sol';
import './Campaign.sol';

contract CrowdFund {
  using SafeMath for uint256;
  using Utils for *;

  Campaign[] private campaigns;

  // Event to be omitted when campaign is created
  event CampaignStarted(
    address contractAddress,
    address campaignOwner,
    string campaignTitle,
    string campaignDesc,
    uint256 deadline,
    uint256 budget
  );

  mapping (address => address[]) owners;

  /**
  * @dev Function for starting Campaign
  * @param _title Title of the campaign
  * @param _description Brief description about the campaign
  * @param _durationInMin Campaign deadline in days
  * @param _budget Campaign budget in wei
  */
  function create(
    string memory _title,
    string memory _description,
    uint _durationInMin,
    uint _budget
  ) external {
    uint duration = now.add(Utils.minutesToSeconds(_durationInMin));
    Campaign newCampaign = new Campaign(msg.sender, _title, _description, duration, _budget);
    campaigns.push(newCampaign);
    emit CampaignStarted(
      address(newCampaign),
      msg.sender,
      _title,
      _description,
      duration,
      _budget
    );
  }

  /**
  * @dev Function to retrieve all campaigns
  * @return A list of all campaign' contract addreses
  */
  function getCampaigns() external view returns(Campaign[] memory) {
    return campaigns;
  }
}

