//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0 <0.7.0;
import './CrowdFunding.sol';

contract TestCrowdFunding is CrowdFunding {
    uint time;

    constructor() public CrowdFunding() {}

    function currentTime() internal view returns(uint) {
        return time;
    }

    function setCurrentTime(uint newTime) public {
        time = newTime;
    }
}