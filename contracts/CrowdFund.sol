//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0 < 0.7.0;

// Importing OpenZeppelin's SafeMath Implementation
import '@openzeppelin/math/SafeMath.sol';

import './Utils.sol';

contract CrowdFunding {
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

contract Campaign {
  using SafeMath for uint256;

  enum State {
    Fundraising,
    Expired,
    Successful
  }

  // State variables
  address payable public owner;
  uint public budget; // required to reach at least this much, else everyone gets refund
  uint public deadline;
  uint256 public currentBalance;
  uint public numberOfContributors;
  uint public approvals;
  string public title;
  string public description;
  State public state = State.Fundraising; // initialize on create
  mapping (address => uint) public contributions;
  mapping (address => uint) public approvers;

  // Events
  event FundingReceived(address contributor, uint amount, uint currenTotal);
  event Paid(address recipient);

  // Modifier to check current state
  modifier inState(State _state) {
    require(state == _state, "Contract not in the right state");
    _;
  }

  // Modifier to check if the function caller is the project creator
  modifier isOwner() {
    require(msg.sender == owner, "Not owner of cmapaign");
    _;
  }

  modifier isNotOwner() {
    require(msg.sender != owner, "Owner of campaign not allowed");
    _;
  }

  modifier isContributor(address addr) {
    require(contributions[addr] > 0, 'Not enough donation to be able to approve');
    _;
  }

  constructor(
    address payable _campaignOwner,
    string memory _campaignTitle,
    string memory _campaignDesc,
    uint _deadline,
    uint _budget
  ) public {
    owner = _campaignOwner;
    budget = _budget;
    deadline = _deadline;
    title = _campaignTitle;
    description = _campaignDesc;
    currentBalance = 0;
  }

  function contribute() external inState(State.Fundraising) isNotOwner() payable {
    contributions[msg.sender] = contributions[msg.sender].add(msg.value);
    currentBalance = currentBalance.add(msg.value);
    numberOfContributors++;
    emit FundingReceived(msg.sender, msg.value, currentBalance);
    isFundingComplete();
  }

  function approve() external isContributor(msg.sender) {
    require(approvers[msg.sender] == 0, "Already approved");
    approvals.add(1);
    approvers[msg.sender].add(1);
  }

  function withdraw() external payable inState(State.Successful) returns(bool) {
    require((approvals/numberOfContributors)*100 > 50, 'amount of allowed approvals not reached');
    require(!beforeDeadline(), 'Cannot withdraw before a deadline');

    uint256 totalRaised = currentBalance;
    currentBalance = 0;

    if (owner.send(totalRaised)) {
      emit Paid(owner);
      return true;
    } else {
      currentBalance = totalRaised;
      state = State.Successful;
    }

    return false;
  }

  function getRefund() external isContributor(msg.sender) payable returns(bool) {
    uint amountToRefund = contributions[msg.sender];
    contributions[msg.sender] = 0;

    if (!msg.sender.send(amountToRefund)) {
      contributions[msg.sender] = amountToRefund;
      return false;
    } else {
      currentBalance = currentBalance.sub(amountToRefund);
    }

    return true;
  }

  function getDetails() public view returns (
    address payable campaignOwner,
    string memory campaignTitle,
    string memory campaignDesc,
    uint256 campaignDeadline,
    State currentState,
    uint256 currentAmount,
    uint256 campaignBudget
  ) {
    campaignOwner = owner;
    campaignTitle = title;
    campaignDesc = description;
    campaignDeadline = deadline;
    currentState = state;
    currentAmount = currentBalance;
    campaignBudget = budget;
  }

  /**
  * @dev Function to change the project state depending on conditions.
  */
  function isFundingComplete() public {
    if (currentBalance >= budget) {
      state = State.Successful;
    } else if (!beforeDeadline()) {
      state = State.Expired;
    }
  }

  /**
  * @dev function for preventing creator from withdrawing funds before campaign deadline day
  * @return bool
  */
  function beforeDeadline() internal view returns(bool) {
    return currentTime() < deadline;
  }

  /**
  * @dev function to return current time
  * @return uint
   */
  function currentTime() internal view returns(uint) {
    return now;
  }
}