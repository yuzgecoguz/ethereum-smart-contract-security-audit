// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title VulnerableContract
 * @author Oguzhan Yuzgec
 * @notice Educational smart contract demonstrating 9 common Ethereum vulnerabilities
 * @dev This contract is intentionally vulnerable for security research and tool benchmarking.
 *      DO NOT deploy this contract on mainnet or any production environment.
 *
 * Vulnerabilities demonstrated:
 *   1. Private Variable Exposure
 *   2. Replay Signature Attack
 *   3. Depegging / Price Manipulation
 *   4. Reentrancy Attack
 *   5. Integer Overflow/Underflow
 *   6. Gas Griefing (Unbounded Loop)
 *   7. Signature Replay (executeWithSignature)
 *   8. Depegging (Unprotected Price Update)
 *   9. Frontrunning (Mempool Visibility)
 */
contract VulnerableContract {
    // =========================================================================
    // Vulnerability 1: Private Variable Exposure
    // "private" only restricts Solidity-level access. Data is still readable
    // on-chain via eth_getStorageAt or block explorers.
    // =========================================================================
    private uint256 privateBalance;
    private mapping(address => uint256) privateUserData;

    mapping(address => uint256) public balances;
    mapping(bytes => bool) public usedSignatures;

    // Vulnerability 3: Depegging - hardcoded peg with no oracle protection
    uint256 public peggedPrice = 1 ether;

    address public owner;

    constructor() {
        owner = msg.sender;
        privateBalance = 1000 ether;
    }

    // =========================================================================
    // Vulnerability 4: Reentrancy Attack
    // External call is made BEFORE state update, allowing recursive withdrawal.
    // Fix: Use Checks-Effects-Interactions pattern or ReentrancyGuard.
    // =========================================================================
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");

        // VULNERABLE: Sends ETH before updating balance
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        // State update happens after external call - too late
        balances[msg.sender] = 0;
    }

    // =========================================================================
    // Vulnerability 5: Integer Overflow/Underflow
    // Using `unchecked` block bypasses Solidity 0.8+ built-in overflow checks.
    // =========================================================================
    function unsafeMath(uint256 amount) public {
        unchecked {
            balances[msg.sender] += amount;
            if (balances[msg.sender] < amount) {
                balances[msg.sender] = 0;
            }
        }
    }

    // =========================================================================
    // Vulnerability 6: Gas Griefing (Unbounded Loop)
    // An attacker can pass an extremely large array, causing the transaction
    // to exceed block gas limit and effectively DoS the function.
    // =========================================================================
    function expensiveOperation(uint256[] memory data) public {
        for (uint256 i = 0; i < data.length; i++) {
            privateUserData[msg.sender] += data[i];
        }
    }

    // =========================================================================
    // Vulnerability 7: Replay Signature Attack
    // While this implementation tracks used signatures, it lacks chain ID
    // and nonce validation, making cross-chain replay possible.
    // =========================================================================
    function executeWithSignature(bytes memory signature, uint256 amount) public {
        require(!usedSignatures[signature], "Signature already used");
        usedSignatures[signature] = true;
        balances[msg.sender] += amount;
    }

    // =========================================================================
    // Vulnerability 8: Depegging - Unprotected Price Update
    // Anyone can call this function to manipulate the pegged price.
    // Fix: Add access control (onlyOwner) and use a decentralized oracle.
    // =========================================================================
    function updatePeggedPrice(uint256 newPrice) public {
        peggedPrice = newPrice;
    }

    // =========================================================================
    // Vulnerability 9: Frontrunning
    // Bid transactions are visible in the mempool before confirmation.
    // Miners or MEV bots can frontrun by submitting a higher bid first.
    // Fix: Use commit-reveal scheme or private mempool (Flashbots).
    // =========================================================================
    function placeBid(uint256 bidAmount) public payable {
        require(msg.value == bidAmount, "Incorrect bid amount");
        require(bidAmount > balances[address(this)], "Bid too low");

        if (balances[address(this)] > 0) {
            (bool success, ) = owner.call{value: balances[address(this)]}("");
            require(success, "Refund failed");
        }

        balances[address(this)] = bidAmount;
        owner = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Vulnerability 1 continued: Exposing private data through a public getter
    function getPrivateBalance() public view returns (uint256) {
        return privateBalance;
    }
}
