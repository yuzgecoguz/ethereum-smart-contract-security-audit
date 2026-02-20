// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title PriceOracleManipulation
 * @author Oguzhan Yuzgec
 * @notice Demonstrates a lending contract vulnerable to oracle manipulation
 * @dev This contract uses a single external price feed without any validation,
 *      Time-Weighted Average Price (TWAP), or sanity checks. An attacker can
 *      manipulate the oracle (e.g., via flash loan on a shallow-liquidity AMM)
 *      to inflate collateral value and overborrow.
 *
 * Attack vector (Flash Loan Oracle Manipulation):
 *   1. Attacker takes flash loan of X ETH
 *   2. Swaps X ETH into a shallow-liquidity AMM, massively inflating the price
 *   3. Deposits tokens as collateral into this lending contract
 *   4. Borrows ETH at the manipulated (inflated) oracle price
 *   5. Repays flash loan, keeps profit
 *
 * Real-world impact:
 *   - Mango Markets: ~$114M exploit (Oct 2022)
 *   - Harvest Finance: ~$34M exploit (Oct 2020)
 *
 * Mitigation:
 *   - Use Time-Weighted Average Price (TWAP) oracles
 *   - Use Chainlink decentralized price feeds
 *   - Implement minimum liquidity thresholds
 *   - Add price deviation circuit breakers
 *
 * See also: oracle-manipulation-attack-demo repository for a full
 *           working exploit demonstration with Hardhat tests.
 */

interface IPriceFeed {
    function getLatestPrice() external view returns (int256);
}

contract PriceOracleManipulation {
    address public owner;
    IPriceFeed public priceFeed;

    constructor(address _priceFeed) {
        owner = msg.sender;
        priceFeed = IPriceFeed(_priceFeed);
    }

    /// @notice Borrow ETH using token collateral valued by the oracle
    /// @dev VULNERABLE: No TWAP, no sanity check, no minimum liquidity requirement
    function borrow(uint256 amount) public {
        int256 price = priceFeed.getLatestPrice();
        require(price > 0, "Price must be positive");

        // Collateral value is directly derived from a single oracle read
        // If the oracle is manipulated, the attacker can overborrow
        uint256 collateralValue = uint256(price) * amount;

        // Borrow logic would execute here based on manipulated collateralValue
        // allowing the attacker to extract more ETH than their real collateral is worth
    }

    function repay(uint256 amount) public {
        // Repayment logic placeholder
    }
}
