// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import './interfaces/ICrowdCoyToken.sol';
import './ERC20.sol';

contract CrowdCoyToken is ERC20, ICrowdCoyToken {
  string public name;

  string public symbol;

  uint8 public decimals;

  bool public initialized = false;

  function initialize(
    address _owner,
    string calldata _name,
    string calldata _symbol,
    uint8 _decimals
    ) external {
      require(initialized == false, 'CrowdCoyToken: ALREADY_INITIALIZED');
      name = _name;
      symbol = _symbol;
      decimals = _decimals;
      initialized = true;
  }

  function mint(address recipient, uint amount) external {
      _mint(recipient, amount);
    }

  function burn(address recipient, uint amount) external {
    _burn(recipient, amount);
  }
}