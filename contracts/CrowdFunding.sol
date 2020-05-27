//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0 < 0.7.0;

import './Utils.sol';

// Documentation: https://coursetro.com/posts/code/102/Solidity-Mappings-&-Structs-Tutorial
contract CrowdFunding {

    using Utils for *;

    event CampaignStarted(address addr, uint budget, string name);
    event CampaignCompleted(string id, address addr, uint totalCollected, bool succeded, bool active);

    enum State {
        Ongoing,
        Failed,
        Succeded,
        Paid
    }

    struct Funder {
        address addr;
        uint amount;
    }

    struct Campaign {
        address payable beneficiary;
        string name;
        uint budget;
        uint approval;
        uint numFunders;
        uint received;
        uint deadline;
        bool success;
        bool isActive;
        mapping (address => Funder) funders;
    }
    mapping(string => Campaign) public userCampaign;
    string[] public campaigns;

    modifier isFunder(string memory _id, address addr) {
        require(userCampaign[_id].funders[addr].addr == addr, 'Not a funder of this campaign');
        _;
    }

    constructor() public {}

    function create(string memory _name, uint _targetAmount, uint _durationInMin, address payable _beneficiary, string memory _id) public {
        userCampaign[_id] = Campaign(_beneficiary, _name, _targetAmount, 0, 0, 0,
            currentTime() + Utils.minutesToSeconds(_durationInMin), false, true);
        campaigns.push(_id);
        emit CampaignStarted(_beneficiary, _targetAmount, _name);
    }

    function contribute(string memory _id) public payable {
        userCampaign[_id].funders[msg.sender] = Funder({addr: msg.sender, amount: msg.value});
        userCampaign[_id].received += msg.value;
        userCampaign[_id].numFunders++;

        if (userCampaign[_id].received >= userCampaign[_id].budget) {
            userCampaign[_id].success = true;
        }
    }

    function finishCampaign(string memory _id) public {
        require(!beforeDeadline(_id), 'Cannot end campaign before a deadline');
        require(userCampaign[_id].beneficiary == msg.sender, 'Not authorized to end this campaign');
        userCampaign[_id].isActive = false;
        emit CampaignCompleted(_id, msg.sender, userCampaign[_id].received, userCampaign[_id].success, userCampaign[_id].isActive);
    }

    function approve(string memory _id) public isFunder(_id, msg.sender) {
        require(userCampaign[_id].funders[msg.sender].amount > 0, 'Not enough donation to be able to approve');
        userCampaign[_id].approval++;
    }

    function reimburse(string memory _id) public payable {
        require(userCampaign[_id].funders[msg.sender].amount > 0, 'Nothing was contributed');
        uint contributed = userCampaign[_id].funders[msg.sender].amount;
        userCampaign[_id].funders[msg.sender].amount = 0;
        if (!msg.sender.send(contributed)) {
            userCampaign[_id].funders[msg.sender].amount = contributed;
        }
    }

    function withdraw(string memory _id) public payable {
        //before they can withdraw they would need the approval of 50% of donaters
        // budget doesnt need to be met before user can request to withdraw
        // but usser cant withdraw before end of deadline
        require((userCampaign[_id].approval/userCampaign[_id].numFunders)*100 > 50, 'amount of allowed approvals not reached');
        require(!beforeDeadline(_id), 'Cannot withdraw before a deadline');

        if (userCampaign[_id].beneficiary.send(userCampaign[_id].received)) {
            userCampaign[_id].isActive = false;
        }
    }

    function getCampaignCount() public view returns(uint) {
        return campaigns.length;
    }

    function beforeDeadline(string memory _id) public view returns(bool) {
        return currentTime() < userCampaign[_id].deadline;
    }

    function currentTime() internal view returns(uint) {
        return now;
    }
}