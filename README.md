# Ethereum Smart Contract Security Audit Benchmark

[![Solidity](https://img.shields.io/badge/Solidity-0.8.x-363636?logo=solidity)](https://soliditylang.org/)
[![Ethereum](https://img.shields.io/badge/Ethereum-Smart%20Contracts-3C3C3D?logo=ethereum)](https://ethereum.org/)
[![Security](https://img.shields.io/badge/Security-Vulnerability%20Analysis-red)](https://github.com/yuzgecoguz/ethereum-smart-contract-security-audit)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> Comparative analysis of static and dynamic smart contract vulnerability detection tools on the Ethereum blockchain.

## Overview

This repository contains the artifacts from my **MSc Cyber Security thesis** at Hoca Ahmet Yesevi International University. The research evaluates **5 industry-standard vulnerability detection tools** across **3 critical vulnerability categories** using intentionally vulnerable Solidity smart contracts and established benchmark datasets.

### Research Question

*Which static and dynamic analysis tools are most effective at detecting specific vulnerability types in Ethereum smart contracts, and how do they compare in terms of accuracy, precision, recall, and F1-score?*

## Vulnerability Categories

| # | Category | Description | Real-World Impact |
|---|----------|-------------|-------------------|
| 1 | **Reentrancy** | External calls before state updates allow recursive fund drainage | The DAO hack ($60M, 2016) |
| 2 | **Access Control** | Improper authorization (tx.origin, unprotected functions) | Parity Wallet ($150K ETH, 2017) |
| 3 | **Price Oracle Manipulation** | Flash loan attacks on shallow-liquidity AMM price feeds | Mango Markets ($114M, 2022) |

## Analysis Tools Compared

| Tool | Type | Method |
|------|------|--------|
| **[Slither](https://github.com/crytic/slither)** | Static Analysis | AST-based pattern detection, data flow analysis |
| **[Mythril](https://github.com/Consensys/mythril)** | Dynamic Analysis | Symbolic execution, SMT solving |
| **[Oyente](https://github.com/enzymefinance/oyente)** | Static Analysis | Control flow graph analysis |
| **[Solhint](https://github.com/protofire/solhint)** | Linter (Static) | Rule-based style and security checks |
| **[SmartCheck](https://github.com/smartdec/smartcheck)** | Static Analysis | XML-based pattern matching |

## Tool Comparison Results

Performance metrics on the test dataset (20% holdout):

| Tool | Vulnerability | Accuracy | Precision | Recall | F1-Score |
|------|--------------|----------|-----------|--------|----------|
| **Slither** | Reentrancy | 0.95 | 0.93 | 0.96 | 0.94 |
| **Slither** | Access Control | 0.92 | 0.90 | 0.88 | 0.89 |
| **Slither** | Oracle Manipulation | 0.78 | 0.72 | 0.65 | 0.68 |
| **Mythril** | Reentrancy | 0.93 | 0.91 | 0.94 | 0.92 |
| **Mythril** | Access Control | 0.88 | 0.85 | 0.82 | 0.83 |
| **Mythril** | Oracle Manipulation | 0.75 | 0.70 | 0.60 | 0.65 |
| **Oyente** | Reentrancy | 0.82 | 0.78 | 0.80 | 0.79 |
| **Oyente** | Access Control | 0.70 | 0.65 | 0.62 | 0.63 |
| **Oyente** | Oracle Manipulation | 0.60 | 0.55 | 0.42 | 0.48 |
| **Solhint** | Reentrancy | 0.68 | 0.62 | 0.58 | 0.60 |
| **Solhint** | Access Control | 0.75 | 0.70 | 0.72 | 0.71 |
| **Solhint** | Oracle Manipulation | 0.52 | 0.48 | 0.35 | 0.40 |
| **SmartCheck** | Reentrancy | 0.72 | 0.68 | 0.70 | 0.69 |
| **SmartCheck** | Access Control | 0.74 | 0.69 | 0.66 | 0.67 |
| **SmartCheck** | Oracle Manipulation | 0.55 | 0.50 | 0.38 | 0.43 |

> **Key Finding**: Slither and Mythril significantly outperform other tools. Price Oracle Manipulation is the hardest vulnerability to detect across all tools. A hybrid static + dynamic approach is recommended.

## Repository Structure

```
contracts/
├── VulnerableContract.sol          # 9 vulnerabilities in one contract
├── ReentrancyVulnerability.sol     # Classic reentrancy pattern
├── InsecureRandomness.sol          # Predictable on-chain randomness
├── AccessControlVulnerability.sol  # tx.origin authentication bypass
└── PriceOracleManipulation.sol     # Oracle without TWAP protection

analysis/
├── slither/                        # Slither setup and findings
├── mythril/                        # Mythril setup and findings
├── oyente/                         # Oyente setup and findings
├── solhint/                        # Solhint setup and findings
└── smartcheck/                     # SmartCheck setup and findings

results/
└── tool-comparison.md              # Detailed metrics and analysis

docs/
└── vulnerability-categories.md     # In-depth vulnerability explanations
```

## Quick Start

### Run Slither Analysis
```bash
pip install slither-analyzer
solc-select install 0.8.20 && solc-select use 0.8.20
slither contracts/VulnerableContract.sol
```

### Run Mythril Analysis
```bash
docker pull mythril/myth
docker run -v $(pwd)/contracts:/tmp mythril/myth analyze /tmp/VulnerableContract.sol --solv 0.8.20
```

### Run Solhint Linting
```bash
npm install -g solhint
solhint contracts/*.sol
```

See the [analysis/](analysis/) directory for detailed setup instructions for each tool.

## Datasets Referenced

This research utilized the following established benchmark datasets (not included in this repo due to size):

| Dataset | Size | Source |
|---------|------|--------|
| [SmartBugs Curated](https://github.com/smartbugs/smartbugs-curated) | 143 contracts, 10 categories | ICSE 2020 |
| [SmartBugs Wild](https://github.com/smartbugs/smartbugs-wild) | 47,398 unique contracts | Ethereum mainnet via BigQuery |
| [SolidiFI Benchmark](https://github.com/DependableSystemsLab/SolidiFI) | 9,369 injected bugs, 7 types | ASE 2020 |

## Key Findings

1. **Slither** achieves the highest overall F1-scores across all vulnerability categories, with fast analysis times suitable for CI/CD integration
2. **Mythril** provides the deepest analysis through symbolic execution but at significantly higher computational cost
3. **Price Oracle Manipulation** is the most challenging vulnerability to detect — all tools struggle with F1-scores below 0.70
4. **SmartCheck and Oyente** show high false positive rates and limited support for modern Solidity (0.8.x)
5. **No single tool is sufficient** — a hybrid approach combining static analysis (Slither) with dynamic analysis (Mythril) is recommended for comprehensive security assessment

## Related Repository

For a complete, runnable demonstration of an oracle manipulation attack using flash loans:

**[oracle-manipulation-attack-demo](https://github.com/yuzgecoguz/oracle-manipulation-attack-demo)** — Full Hardhat project with test suite showing a 2.8 ETH profit attack scenario

## References

- Rameder, H., di Angelo, M., & Salzer, G. (2022). Review of Automated Vulnerability Analysis of Smart Contracts on Ethereum. *Frontiers in Blockchain*, 5:814977.
- Durieux, T., et al. (2020). Empirical Review of Automated Analysis Tools on 47,587 Ethereum Smart Contracts. *ICSE 2020*.
- Ghaleb, A., & Pattabiraman, K. (2020). How Effective Are Smart Contract Analysis Tools? *ASE 2020*.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## Author

**Oguzhan Yuzgec** — MSc Cyber Security, Hoca Ahmet Yesevi International University

- GitHub: [@yuzgecoguz](https://github.com/yuzgecoguz)
- LinkedIn: [oguzhan-yuzgec](https://www.linkedin.com/in/oguzhan-yuzgec-a72988182/)
