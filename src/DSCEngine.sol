// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

/**
 * @title DSC Engine
 * @author Zer4ch
 * @notice this contract is the core of the DSC system it handles all the logic for mining and redeemin DSC, as well as depositing and withdrawing collateral
 *
 * this System is dsigned as minimal as possible , and have he tokens maintain a 1 token = $1 peg
 * this stable coin has the properties
 * - Exogenous collateral
 * - Dollar pegged
 * - algorithmically stable
 *
 * It is similar to DAI stable coin if DAI has no governance and no fees and was only backed by WETH and WBTC
 *
 * This contract is very loosely based on the idea of the MakerDAO system, but it is not a direct copy.
 *
 */

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";

contract DSCEngine {
    ////////// ERROR //////////
    error DSCEngine__needsMoreThanZero();
    error DSCEngine_tokenAddressesAndPriceFeedAddressesLengthMismatch();
    error DSCEngine_tokenNotAllowed();

    ////////// STATE VARIABLES //////////
    mapping(address token => address priceFeed) private s_priceFeedAddress; // list of collateral tokens allowed

    DecentralizedStableCoin private immutable i_dsc;
    ////////// MODIFIERS //////////

    modifier moreThanZero(uint256 _amount) {
        if (_amount == 0) {
            revert DSCEngine__needsMoreThanZero();
        }
        _;
    }

    modifier isAllowed() {
        if (s_priceFeedAddress[token] == address(0)) {
            revert DSCEngine_tokenNotAllowed();
        }
        _;
    }

    //////////// FUNCTIONS //////////

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine_tokenAddressesAndPriceFeedAddressesLengthMismatch();
        }
        for (uint256 i = 0; i < tokenAddresses.lenght; i++) {
            s_priceFeedAddress[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    /////////// EXTERNAL FUNCTIONS //////////
    function depositCollateralAndMintDSC() external {}

    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowed(tokenCollateralAddress)
    {}

    function redeemCollateralForDsc() external {}
    function redeemCollateral() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view returns (uint256) {}
}
