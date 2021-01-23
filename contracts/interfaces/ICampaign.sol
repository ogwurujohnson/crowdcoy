// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

interface ICampaign {
  enum State {
    Fundraising,
    Expired,
    Successful
  }

  event Funded(address contributor, uint amount, uint currenTotal);
  event Paid(address recipient);

  function contribute() external;
  function approve() external;
  function withdraw() external returns(bool);
  function getRefund() external returns(bool);
  function isFundingComplete() external;

  function getDetails() external view returns(
    address payable campaignOwner, 
    string memory campaignTitle,
    string memory campaignDesc,
    uint256 campaignDeadline,
    State currentState,
    uint256 currentAmount,
    uint256 campaignBudget
  );
  function beforeDeadline() external view returns(bool);
  function currentTime() external view returns(uint);
}