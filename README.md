# Macroeconomic Data Analysis Toolkit

This repository contains a collection of standalone **R scripts** developed during my coursework and independent research. These tools perform automated data retrieval, time-series decomposition, and empirical visualization of U.S. macroeconomic relationships.

## Contents

### FRED Macro Analysis Script

This script accesses **U.S. macroeconomic data** directly from the **Federal Reserve Economic Data (FRED)** database via the FRED API and systematically explores relationships between key variables.

**Key Features:**

- 🔹 **Automated Data Retrieval:** Connects to the FRED API to download time series for GDP, M2 money supply, inflation, unemployment, and interest rates.
- 🔹 **Time-Series Decomposition:** Applies the **Hodrick-Prescott (HP) filter** to extract trend and cyclical components for each variable.
- 🔹 **Linear Regression Estimation:** Estimates pairwise linear regression models across multiple variable combinations to explore empirical macroeconomic linkages.
- 🔹 **Comprehensive Visualization:** Generates plots for:
  - Raw levels and growth rates
  - Trend vs. cyclical deviations
  - Scatter plots with regression lines for variable pairs

**Variables Analyzed:**

| Variable | Source | Transformation |
|----------|--------|----------------|
| GDP | FRED | Levels, growth rates, cyclical component |
| M2 Money Supply | FRED | Levels, growth rates, cyclical component |
| Inflation | FRED | Derived from price indices |
| Unemployment | FRED | Rate, cyclical deviations |
| Interest Rates | FRED | Policy and market rates |

---

*These scripts are part of my portfolio, demonstrating applied skills in macroeconomic data analysis, API-based data retrieval, time-series filtering, and empirical visualization in R.*
