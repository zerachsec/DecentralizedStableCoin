// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title Decentralized stable coin
 * @author Zer4ch
 * @notice This is the contract meant to be governed by the DSCEngine. this contract is the just the ERC20 implemebntation of the stable coin
 */

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin_mustBeMoreThanZero();
    error DecentralizedStableCoin_burnExceedsBalance();
    error DecentralizedStableCoin_NotZeroAddress();
    // Decentralized Stable Coin logic will be implemented here
    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(msg.sender) {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin_mustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStableCoin_burnExceedsBalance();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin_NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin_mustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
