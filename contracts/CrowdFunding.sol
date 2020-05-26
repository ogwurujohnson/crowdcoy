//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0 < 0.7.0;

import './Utils.sol';

// Documentation: https://coursetro.com/posts/code/102/Solidity-Mappings-&-Structs-Tutorial
contract CrowdFunding {

    using Utils for *;

    event CampaignStarted(address addr, uint budget, string name);
    event CampaignCompleted(string id, address addr, uint totalCollected, bool succeded, bool isActive);

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
        Campaign storage c = userCampaign[_id];
        require(c.funders[addr].addr == addr, 'Not a funder of this campaign');
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
        Campaign storage c = userCampaign[_id];
        c.funders[msg.sender] = Funder({addr: msg.sender, amount: msg.value});
        c.received += msg.value;

        if (c.received >= c.budget) {
            c.success = true;
        }
    }

    function finishCampaign(string memory _id) public {
        Campaign memory c = userCampaign[_id];
        require(c.beneficiary == msg.sender, 'Not authorized to end this campaign');
        c.isActive = false;
        emit CampaignCompleted(_id, msg.sender, c.received, c.success, c.isActive);
    }

    function approve(string memory _id) public isFunder(_id, msg.sender) {
        Campaign storage c = userCampaign[_id];
        require(c.funders[msg.sender].amount > 0, 'Not enough donation to be able to approve');
        c.approval++;
    }

    function reimburse(string memory _id) public payable {
        Campaign storage c = userCampaign[_id];
        require(c.funders[msg.sender].amount > 0, 'Nothing was contributed');
        uint contributed = c.funders[msg.sender].amount;
        c.funders[msg.sender].amount = 0;

        if (!msg.sender.send(contributed)) {
            c.funders[msg.sender].amount = contributed;
        }
    }

    function withdraw(string memory _id) public payable {
        //before they can withdraw they would need the approval of 50% of donaters
        // budget doesnt need to be met before user can request to withdraw
        // but usser cant withdraw before end of deadline
        Campaign storage c = userCampaign[_id];
        require((c.approval/c.numFunders)*100 > 50, 'amount of allowed approvals not reached');
        require(!beforeDeadline(_id), 'Cannot withdraw before a deadline');

        if (c.beneficiary.send(c.received)) {
            c.isActive = false;
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