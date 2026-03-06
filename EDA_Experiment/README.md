# Exploratory Data Analysis (EDA) on Iris Dataset

This directory contains the codebase for **Experiment 9: Exploratory Data Analysis (EDA) and Feature Analysis using Pandas and Seaborn**.

## 📦 How to Clone this Specific Experiment
To prevent different experiments from overlapping, this code is versioned via a Git Tag. You can download *only* this exact EDA code by running:
```bash
git clone --branch v9.0-eda https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
Exploratory Data Analysis (EDA) is the foundational process of evaluating a dataset via statistical summaries and visual mapping *before* applying machine learning models. The primary goal is to establish baseline characteristics, map feature correlation, detect null values, and determine outliers.

This codebase operates against the famous `sklearn.datasets.load_iris()` matrix, assessing 150 floral dimension samples across three target Species (Setosa, Versicolor, Virginica).

---

## 🚀 How to Execute the Analytics

To accommodate both interactive analysis and headless terminal automation, the EDA process is broken into two pipelines:

### 1. Headless Automation (Data Engineering Mode)
1. Double-click to execute the orchestrator:
   ```bat
   run_eda.cmd
   ```
2. The `eda_script.py` module will instantly boot in the background:
   - **Text Output:** Descriptive statistics (`df.describe()`), schema definitions (`df.info()`), and missing value checks (`df.isnull().sum()`) are printed sequentially to the terminal.
   - **Image Export:** By passing standard console UI freezes, the script safely dumps 4 high-quality PNGs (Histograms, Heatmaps) natively to the localized `/output_plots/` directory.

### 2. Interactive Notebook (Data Science Mode)
1. Launch Anaconda Prompt and type `jupyter notebook`.
2. Open `Experiment_9_EDA.ipynb`.
3. Press **Run** successively through the blocks. The EDA code has been completely mapped into an interactive Jupyter array matching the standard PDF workflow verbatim, allowing dynamic re-rendering.

## ✨ Statistical Mapping Actions
- `df.head()`: Examined the first five structural rows ensuring correct dataframe mapping natively.
- `df.describe()`: Calculated absolute variance matrices including `count`, `mean`, `std`, and quartile logic (25%, 50%, 75%).
- `df.isnull().sum()`: Evaluated matrix continuity verifying zero missing rows across the index.

## ✨ Data Visualizations Rendered
- **Sepal Distribution (Histogram):** Rendered absolute occurrence counts grouped linearly into frequency bins representing sepal lengths.
- **Petal Spread (Boxplot):** Computed upper/lower quartile whiskers to visually trace the geometric density limits without manual calculus.
- **Multivariate Relationship (Pairplot):** Cross-matched every independent feature dynamically against each other utilizing species categorical colors (`hue='species'`).
- **Feature Importance (Correlation Heatmap):** Extracted `df.corr()` converting absolute numerical bindings into a continuous `coolwarm` gradient logic highlighting which variables most severely impact categorization.
