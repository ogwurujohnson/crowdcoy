// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

interface ICrowdFund {
  function create(
    string memory _title,
    string memory _description,
    uint _durationInMin,
    uint _budget
  ) external;

  function getCampaigns() external view returns()
}