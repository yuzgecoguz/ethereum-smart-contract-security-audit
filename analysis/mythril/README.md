# Mythril Analysis

[Mythril](https://github.com/Consensys/mythril) is a security analysis tool for EVM bytecode. It detects security vulnerabilities in Ethereum smart contracts using symbolic execution, SMT solving, and taint analysis.

## Setup

```bash
# Using Docker (recommended)
docker pull mythril/myth

# Or via pip
pip install mythril
```

## Running Analysis

```bash
# Analyze using Docker
docker run -v $(pwd)/../../contracts:/tmp mythril/myth analyze /tmp/VulnerableContract.sol --solv 0.8.20

# Analyze individual contracts
docker run -v $(pwd)/../../contracts:/tmp mythril/myth analyze /tmp/ReentrancyVulnerability.sol --solv 0.8.20

# With specific execution depth
docker run -v $(pwd)/../../contracts:/tmp mythril/myth analyze /tmp/PriceOracleManipulation.sol --solv 0.8.20 --execution-timeout 300
```

## Key Detection Capabilities

| SWC ID | Vulnerability | Detection |
|--------|--------------|-----------|
| SWC-107 | Reentrancy | Symbolic execution traces external calls |
| SWC-101 | Integer Overflow/Underflow | SMT solver verifies arithmetic bounds |
| SWC-115 | Authorization through tx.origin | Detects tx.origin in require statements |
| SWC-120 | Weak Randomness | Identifies block variable usage |
| SWC-116 | Timestamp Dependence | Tracks block.timestamp constraints |

## Findings on VulnerableContract.sol

Mythril detected:
- **SWC-107**: Reentrancy vulnerability in `withdraw()` - external call to user-supplied address
- **SWC-101**: Integer overflow in `unsafeMath()` within unchecked block
- **SWC-113**: DoS with failed call in `placeBid()`

## Performance

- **Analysis time**: ~30-120 seconds per contract (significantly slower than Slither)
- **Depth of analysis**: Deepest among tools tested - explores all execution paths
- **Trade-off**: Higher accuracy at the cost of computation time
- **Best for**: Pre-deployment audits where thoroughness matters more than speed
