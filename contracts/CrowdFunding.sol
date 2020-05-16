pragma solidity >=0.4.0 < 0.7.0;

// Documentation: https://coursetro.com/posts/code/102/Solidity-Mappings-&-Structs-Tutorial
contract CrowdFunding {

    event campaignStarted(address addr, uint budget, uint name);
    event campaignCompleted(address addr, uint totalCollected, bool succeded);

    enum State {
        Ongoing,
        Failed,
        Succeded,
        Paid
    }

    struct campaign {
        address beneficiary;
        string name;
        uint budget;
        uint received;
        uint deadline;
    }
    mapping(string => campaign) userCampaign;
    address[] public campaigns;

    constructor() public {

    }

    function create(string memory _name, uint _targetAmount, uint _durationinMin, address payable _beneficiary) public {

    }

    function contribute(address _to, uint _amount) public payable {

    }

    function reimburse(address _from) public payable {

    }

    function getAllCampaigns() public view {
        
    }

    function getCampaignCount() public view {

    }

    function getSingleCampaign() public view {

    }
}