# Tool Comparison Results

## Methodology

Each tool was evaluated against the same set of vulnerable smart contracts across three vulnerability categories. The dataset was split 80% training / 20% test. Metrics were calculated using standard classification formulas:

- **Accuracy** = (TP + TN) / (TP + TN + FP + FN)
- **Precision** = TP / (TP + FP)
- **Recall** = TP / (TP + FN)
- **F1-Score** = 2 * (Precision * Recall) / (Precision + Recall)

> F1-score was chosen as the primary metric because accuracy alone is misleading due to class imbalance — Price Oracle Manipulation contracts represent ~5% of the dataset, yielding >97% accuracy even with poor recall.

## Results Summary

### Reentrancy Detection

| Tool | Accuracy | Precision | Recall | F1-Score | Avg. Time |
|------|----------|-----------|--------|----------|-----------|
| Slither | 0.95 | 0.93 | 0.96 | **0.94** | ~3s |
| Mythril | 0.93 | 0.91 | 0.94 | **0.92** | ~60s |
| SmartCheck | 0.72 | 0.68 | 0.70 | 0.69 | ~3s |
| Oyente | 0.82 | 0.78 | 0.80 | 0.79 | ~10s |
| Solhint | 0.68 | 0.62 | 0.58 | 0.60 | <1s |

### Access Control Detection

| Tool | Accuracy | Precision | Recall | F1-Score | Avg. Time |
|------|----------|-----------|--------|----------|-----------|
| Slither | 0.92 | 0.90 | 0.88 | **0.89** | ~3s |
| Mythril | 0.88 | 0.85 | 0.82 | **0.83** | ~45s |
| Solhint | 0.75 | 0.70 | 0.72 | 0.71 | <1s |
| SmartCheck | 0.74 | 0.69 | 0.66 | 0.67 | ~3s |
| Oyente | 0.70 | 0.65 | 0.62 | 0.63 | ~8s |

### Price Oracle Manipulation Detection

| Tool | Accuracy | Precision | Recall | F1-Score | Avg. Time |
|------|----------|-----------|--------|----------|-----------|
| Slither | 0.78 | 0.72 | 0.65 | **0.68** | ~3s |
| Mythril | 0.75 | 0.70 | 0.60 | **0.65** | ~90s |
| Oyente | 0.60 | 0.55 | 0.42 | 0.48 | ~12s |
| SmartCheck | 0.55 | 0.50 | 0.38 | 0.43 | ~4s |
| Solhint | 0.52 | 0.48 | 0.35 | 0.40 | <1s |

## Analysis

### Why Oracle Manipulation is Hardest to Detect

Price oracle manipulation involves cross-contract interactions, economic reasoning about liquidity pools, and understanding of flash loan mechanics. Static analysis tools primarily check code patterns within a single contract, making it difficult to detect vulnerabilities that emerge from the interaction between multiple contracts and DeFi protocols.

### Tool Recommendations by Use Case

| Use Case | Recommended Tool(s) |
|----------|---------------------|
| CI/CD Pipeline (fast feedback) | Slither + Solhint |
| Pre-deployment audit | Slither + Mythril |
| Legacy contract analysis | Slither (broadest Solidity support) |
| Code quality enforcement | Solhint |
| Deep path exploration | Mythril |

### Key Takeaways

1. **No single tool catches everything** — combining static (Slither) and dynamic (Mythril) analysis is essential
2. **Slither offers the best speed-to-accuracy ratio** — ideal for automated pipelines
3. **Mythril provides the deepest analysis** but requires significantly more computation time
4. **SmartCheck and Oyente** have limited utility for modern Solidity (0.8.x) contracts
5. **DeFi-specific vulnerabilities** (oracle manipulation, flash loans) remain a gap in current tooling
