//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0 <0.7.0;
import './CrowdFunding.sol';

contract TestCrowdFunding is CrowdFunding {
    uint time;

    constructor(
        string memory contractName,
        uint targetAmountEth,
        uint durationInMin,
        address payable beneficiaryAddress
    ) public CrowdFunding() {

    }

    function currentTime() internal override view returns(uint) {
        return time;
    }

    function setCurrentTime(uint newTime) public {
        time = newTime;
    }
}