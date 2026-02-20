# Slither Analysis

[Slither](https://github.com/crytic/slither) is a static analysis framework for Solidity developed by Trail of Bits. It runs a suite of vulnerability detectors, prints visual information about contract details, and provides an API to easily write custom analyses.

## Setup

```bash
pip install slither-analyzer
pip install solc-select
solc-select install 0.8.20
solc-select use 0.8.20
```

## Running Analysis

```bash
# Analyze the main vulnerable contract
slither ../../contracts/VulnerableContract.sol

# Analyze individual contracts
slither ../../contracts/ReentrancyVulnerability.sol
slither ../../contracts/AccessControlVulnerability.sol
slither ../../contracts/PriceOracleManipulation.sol
```

## Detectors Used

Slither includes 90+ built-in detectors. Key detectors relevant to this research:

| Detector | Impact | Confidence | Vulnerability |
|----------|--------|------------|---------------|
| `reentrancy-eth` | High | Medium | Reentrancy with ETH transfer |
| `reentrancy-no-eth` | Medium | Medium | Reentrancy without ETH |
| `tx-origin` | Medium | Medium | Dangerous use of tx.origin |
| `unchecked-transfer` | High | Medium | Unchecked token transfer |
| `arbitrary-send-eth` | High | Medium | Functions sending ETH arbitrarily |
| `weak-prng` | High | Medium | Weak pseudo-random number generation |

## Findings on VulnerableContract.sol

Slither successfully detected:
- Reentrancy in `withdraw()` (reentrancy-eth)
- State variable could be declared as immutable (owner)
- Dangerous use of `unchecked` block in `unsafeMath()`
- Missing access control on `updatePeggedPrice()`

## Performance

- **Analysis time**: ~2-5 seconds per contract
- **False positive rate**: Low for reentrancy, moderate for access control
- **Solidity version support**: Excellent (0.4.x - 0.8.x)
