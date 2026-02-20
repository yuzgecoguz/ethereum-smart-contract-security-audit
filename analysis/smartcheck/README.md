# SmartCheck Analysis

[SmartCheck](https://github.com/smartdec/smartcheck) is a static analysis tool that converts Solidity source code into an XML-based intermediate representation and checks it against a set of XPath vulnerability patterns.

## Setup

```bash
# Using npm
npm install @smartdec/smartcheck -g

# Or use the online tool
# https://tool.smartdec.net/
```

## Running Analysis

```bash
smartcheck -p ../../contracts/VulnerableContract.sol
smartcheck -p ../../contracts/ReentrancyVulnerability.sol
```

## Detection Patterns

| Pattern | Severity | Description |
|---------|----------|-------------|
| SOLIDITY_EXTRA_GAS_IN_LOOPS | Medium | Gas inefficiency in loops |
| SOLIDITY_DEPRECATED_CONSTRUCTIONS | Low | Deprecated Solidity features |
| SOLIDITY_VISIBILITY | High | Missing function visibility |
| SOLIDITY_SEND | Medium | Use of send() instead of transfer() |
| SOLIDITY_TX_ORIGIN | High | Authentication via tx.origin |

## Findings

SmartCheck detected:
- Deprecated constructions warnings
- Gas inefficiency in unbounded loops
- Basic tx.origin usage

## Limitations

- **Surface-level analysis**: Relies on pattern matching rather than semantic analysis
- **Higher false positive rate**: XML pattern matching can flag benign code
- **Limited scope**: Cannot detect complex vulnerabilities requiring execution path analysis
- **Solidity version**: Better support for older Solidity versions

## Performance

- **Analysis time**: ~2-5 seconds per contract
- **Best for**: Quick initial scans and code review checklists
- **Not suitable for**: Comprehensive security audits
