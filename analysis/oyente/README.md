# Oyente Analysis

[Oyente](https://github.com/enzymefinance/oyente) is one of the earliest smart contract analysis tools (2016), developed after the infamous DAO hack. It performs static analysis using control flow graph construction.

## Setup

```bash
# Using Docker
docker pull luongnguyen/oyente
docker run -it luongnguyen/oyente
```

## Running Analysis

```bash
# Inside the Docker container
cd /oyente/oyente
python oyente.py -s /path/to/contract.sol
```

## Limitations

> **Note**: Oyente has limited support for Solidity 0.8.x. Contracts may need to be adapted to 0.4.x syntax for compatibility. This tool is included for historical comparison purposes.

| Limitation | Impact |
|-----------|--------|
| Solidity version support | Limited to 0.4.x - 0.6.x |
| Active maintenance | Archived/minimal updates |
| Detection scope | Basic vulnerability patterns only |
| False positive rate | Relatively high |

## Findings

Oyente detected basic reentrancy patterns but struggled with:
- Modern Solidity syntax (unchecked blocks, custom errors)
- Complex access control patterns
- Oracle manipulation scenarios

## Performance

- **Analysis time**: ~5-15 seconds per contract
- **Detection quality**: Limited for modern contracts
- **Historical significance**: Pioneered automated smart contract analysis
