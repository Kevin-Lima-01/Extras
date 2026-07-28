# Macroeconomic Data Analysis Toolkit

This repository contains a collection of standalone R and Python scripts developed during my coursework and independent research. These tools perform automated data retrieval, time-series decomposition, and empirical visualization of U.S. and Brazilian macroeconomic relationships.

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

| Variable        | Source | Transformation                       |
|------------------|--------|---------------------------------------|
| GDP              | FRED   | Levels, growth rates, cyclical component |
| M2 Money Supply  | FRED   | Levels, growth rates, cyclical component |
| Inflation        | FRED   | Derived from price indices           |
| Unemployment     | FRED   | Rate, cyclical deviations            |
| Interest Rates   | FRED   | Policy and market rates               |

---

### Selic vs. Fed Funds & Industrial Production Comparative Analysis (Python)

A Jupyter notebook comparing Brazilian and U.S. monetary policy rates and industrial production, combining data from **BCB/SGS**, **FRED**, and **IBGE/SIDRA** into a single comparative framework.

**Key Features:**

- 🔹 **Multi-Source Data Retrieval:** Pulls the Selic rate via `bcb.sgs`, the Fed Funds rate via `fredapi`, and Brazilian industrial production via `sidrapy`, alongside U.S. industrial production (INDPRO, seasonally adjusted and non-adjusted) from FRED.
- 🔹 **Descriptive & Distributional Analysis:** Computes descriptive statistics, boxplots, and kernel density estimates (KDE) comparing the distribution of Selic vs. Fed Funds rates.
- 🔹 **Correlation Analysis:** Estimates Pearson correlation between series, including decade-by-decade breakdowns (2000s, 2010s, 2020s).
- 🔹 **Spread Analysis:** Calculates and characterizes the Selic–Fed Funds spread (mean, median, and dispersion).
- 🔹 **Comparative Industrial Production:** Visualizes and compares industrial output trajectories for Brazil and the U.S.

**Variables Analyzed:**

| Variable                        | Source        | Notes                                  |
|----------------------------------|---------------|------------------------------------------|
| Selic Rate (Brazil)              | BCB/SGS       | Series 432, spliced across 2000–present |
| Fed Funds Rate (US)               | FRED          | FEDFUNDS                                |
| Industrial Production (US)        | FRED          | INDPRO (SA) and IPB50001N (NSA)          |
| Industrial Production (Brazil)    | IBGE/SIDRA    | Table 8159                              |

---

### PIM-PF Automated Reporting Pipeline (R / R Markdown)

An automated pipeline that generates a monthly HTML "Nota Informativa" on Brazil's **Pesquisa Industrial Mensal – Produção Física (PIM-PF)**, sourced live from **IBGE/SIDRA**.

**Key Features:**

- 🔹 **Automated Data Retrieval:** Pulls both the original and seasonally-adjusted PIM-PF series (Indústria Geral) directly from SIDRA via `sidrar::get_sidra()`.
- 🔹 **Robust Rendering Script:** `render_pim.R` runs pre-flight checks (file existence, required packages, SIDRA API connectivity) before knitting, with structured logging (timestamped, INFO/WARN/ERROR levels) written to `render_log.txt`.
- 🔹 **Derived Indicators:** Computes month-over-month and year-over-year variations, deviation from historical mean, 3-month and 12-month moving averages, and seasonally-adjusted trends over configurable rolling windows.
- 🔹 **Polished HTML Report:** Tabbed sections (historical series, recent variations, trend/smoothing, seasonally-adjusted series, variation panel, summary table) styled with a custom color palette and theme, built with `flatly` Bootstrap theme and floating table of contents.
- 🔹 **Versioned Output:** Automatically saves a dated copy (`PIM_PF_YYYYMM.html`) and a `PIM_PF_LATEST.html` on every successful knit.

**Variables Analyzed:**

| Variable                          | Source      | Transformation                                    |
|-------------------------------------|-------------|----------------------------------------------------|
| PIM-PF Original Series               | IBGE/SIDRA  | Levels, M/M and Y/Y variation                       |
| PIM-PF Seasonally Adjusted Series     | IBGE/SIDRA  | Levels, trend, moving averages (3M/12M)             |

*Authors: Kevin Lima, Leonardo Ono, Lucca Costa.*

---

*These scripts are part of my portfolio, demonstrating applied skills in macroeconomic data analysis, API-based data retrieval, time-series filtering, automated reporting pipelines, and empirical visualization in R and Python.*
