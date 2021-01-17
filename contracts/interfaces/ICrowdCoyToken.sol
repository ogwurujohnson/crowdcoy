// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

interface ICrowdCoyToken {
  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);

  function initialize(
    string calldata _name,
    string calldata _symbol,
    uint _decimals
  ) external;

  function mint(address recipient, uint amount) external;

  function burn(address recipient, uint amount) external;
}