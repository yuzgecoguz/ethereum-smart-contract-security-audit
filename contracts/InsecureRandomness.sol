// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title InsecureRandomness
 * @author Oguzhan Yuzgec
 * @notice Demonstrates insecure on-chain randomness generation
 * @dev Block variables (timestamp, prevrandao, msg.sender) are predictable and
 *      can be manipulated by miners/validators. This makes any "random" number
 *      generated from them deterministic and exploitable.
 *
 * Attack vector:
 *   - Miners can manipulate block.timestamp within a ~15 second range
 *   - block.prevrandao (formerly block.difficulty) is known before block finalization
 *   - msg.sender is known to the caller
 *   - An attacker can precompute the "random" result and only submit when favorable
 *
 * Mitigation:
 *   - Use Chainlink VRF (Verifiable Random Function) for provably fair randomness
 *   - Use commit-reveal schemes for lottery/gaming applications
 */
contract Solidity_InsecureRandomness {
    /// @notice Generates a pseudo-random number using predictable block variables
    /// @dev VULNERABLE: All inputs are known or manipulable before transaction execution
    function generateRandomNumber() public view returns (uint256) {
        uint256 answer = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.prevrandao, msg.sender)
            )
        );
        return answer;
    }
}
