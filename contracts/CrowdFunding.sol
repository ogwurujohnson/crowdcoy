pragma solidity >=0.4.0 < 0.7.0;

import './Utils.sol';

// Documentation: https://coursetro.com/posts/code/102/Solidity-Mappings-&-Structs-Tutorial
contract CrowdFunding {

    using Utils for *;

    event CampaignStarted(address addr, uint budget, uint name);
    event CampaignCompleted(string id, address addr, uint totalCollected, bool succeded);

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
        bool status;
        mapping (address => Funder) funders;
    }
    mapping(string => Campaign) userCampaign;
    string[] public campaigns;
    State public state;

    modifier inState(State expectedState) {
        require(state == expectedState, 'Invalid state');
        _;
    }

    modifier isFunder(string memory _id, address addr) {
        Campaign storage c = userCampaign[_id];
        require(c.funders[addr].addr == addr, 'Not a funder of this campaign');
        _;
    }

    function create(string memory _name, uint _targetAmount, uint _durationInMin, address payable _beneficiary, string memory _id) public {
        userCampaign[_id] = Campaign(_beneficiary, _name, _targetAmount, 0, 0, 0, currentTime() + Utils.minutesToSeconds(_durationInMin), false);
        campaigns.push(_id);
    }

    function contribute(string memory _id) public payable {
        Campaign storage c = userCampaign[_id];
        c.funders[msg.sender] = Funder({addr: msg.sender, amount: msg.value});
        c.received += msg.value;

        if (c.received >= c.budget) {
            c.status = true;
        }
    }

    function finishCampaign(string memory _id) public {
        Campaign memory c = userCampaign[_id];
        if(!c.status) {
            state = State.Failed;
        } else {
            state = State.Succeded;
        }

        emit CampaignCompleted(_id, msg.sender, c.received, c.status);
    }

    function approve(string memory _id) public isFunder(_id, msg.sender) {
        Campaign storage c = userCampaign[_id];
        require(c.funders[msg.sender].amount > 0, 'Not enough donation to be able to approve');
        c.approval++;
    }

    function reimburse(string memory _id) public payable {
        Campaign storage c = userCampaign[_id];
    }

    function withdraw(string memory _id) public payable {
        Campaign storage c = userCampaign[_id];
        require((c.approval/c.numFunders)*100 > 50, 'amount of allowed approvals not reached');
        //before they can withdraw they would need the approval of 50% of donaters
        // and also campaign needs to have a completed status
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