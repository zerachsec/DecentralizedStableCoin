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
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {
    AggregatorV3Interface
} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract DSCEngine {
    ////////// ERROR //////////
    error DSCEngine__needsMoreThanZero();
    error DSCEngine_tokenAddressesAndPriceFeedAddressesLengthMismatch();
    error DSCEngine_tokenNotAllowed();
    error DSCEngine_TransferFailed();
    error DSCEngine_HealthFactorTooLow(uint256 healthFactor);

    ////////// STATE VARIABLES //////////

    uint256 private constant MIN_HEALTH_FACTOR = 1;
    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;
    uint256 private constant PRECISION = 1e18;
    uint256 private constant LIQUIDATION_THRESHOLD = 50;

    mapping(address token => address priceFeed) private s_priceFeedAddress; // list of collateral tokens allowed
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited; // user address -> token address -> amount deposited
    mapping(address user => uint256 amountDscMinted) private s_DSCMinted;
    address[] private s_collateralTokens;

    DecentralizedStableCoin private immutable i_dsc;

    ////////// EVENTS //////////

    event collateralDeposited(address indexed user, address indexed tokenCollateralAddress, uint256 amountCollalteral);

    ////////// MODIFIERS //////////

    modifier moreThanZero(uint256 _amount) {
        if (_amount == 0) {
            revert DSCEngine__needsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
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
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeedAddress[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    /////////// EXTERNAL FUNCTIONS //////////
    function depositCollateralAndMintDSC() external {}

    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit collateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine_TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}
    function redeemCollateral() external {}

    /**
     *
     * @param amountDsctoMint the amount of decentralzed stable coin to mint
     * @notice theu must have more collateral value than the minimum threshold to mint the dsc
     */

    function mintDSC(uint256 amountDsctoMint) external moreThanZero(amountDsctoMint) {
        s_DSCMinted[msg.sender] += amountDsctoMint;
        _revertIFHealthFactorIsBroken(msg.sender);
    }

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view returns (uint256) {}

    /////////// PRIVATE & INTERNAL FUNCTIONS //////////

    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    /**
     *
     *  returns how close to liquidation a user is
     * if a user goes below 1 then they can get liquidated
     */
    function _healthFactor(address user) private view returns (uint256) {
        // total DSC minted
        // total collateral value
        // health factor = (total collateral value * liquidation threshold) / total DSC minted
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
        uint256 collateralAdjustedThreshold = (collateralValueInUsd * LIQUIDATION_THRESHOLD) / PRECISION;
        return (collateralAdjustedThreshold / totalDscMinted);
    }

    function _revertIFHealthFactorIsBroken(address user) internal view {
        // 1. check health factor
        // 2. revert if they dont
        uint256 healthFactore = _healthFactor(user);
        if (healthFactore < MIN_HEALTH_FACTOR) {
            revert DSCEngine_HealthFactorTooLow(healthFactore);
        }
    }

    ///////////// PUBLIC VIEW FUNCTIONS /////////////

    function getAccountCollateralValue(address _user) public view returns (uint256 totalCollateralValueInUsd) {
        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_collateralDeposited[_user][token];
            totalCollateralValueInUsd += getUsdValue(token, amount);
        }
        return totalCollateralValueInUsd;
    }

    function getUsdValue(address token, uint256 amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeedAddress[token]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return ((uint256(price) * ADDITIONAL_FEED_PRECISION) * amount) / PRECISION;
    }
}

