# Data Visualization using Matplotlib and Seaborn

This repository handles **Experiment 7: Visualizing data using Matplotlib and Seaborn for univariate and bivariate analysis** from the assignment PDF.

## 📦 How to Clone this Specific Experiment
To prevent different experiments from overlapping, this code is versioned via a Git Tag. You can download *only* this exact Matplotlib/Seaborn visualization code by running:
```bash
git clone --branch v7.0-visualization https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
Data visualization translates numerical rows into high-level geometric dimensions (color, length, density) allowing us to identify patterns efficiently. This experiment implements `seaborn.load_dataset("diamonds")` and computes nine different visual analytical charts natively.

Because managing Python interactive visualization popups (`plt.show()`) from the terminal can sometimes stall background processes or crash headless machines, we've designed this experiment to dynamically compute and render all analytical plots as high-quality `.png` files, funneling them straight into the `output_plots` folder alongside an interactive Jupyter Notebook.

---

## 🚀 How to Run

There are two primary ways to operate this experiment:

### 1. Fully Automated Python Pipeline (Headless)
If you just want the plots immediately rendered to your disk:
1. Double click the execution script:
   ```bat
   run_visualization.cmd
   ```
2. The script will boot up `pandas`, digest the 54,000-row `diamonds` payload, compute the univariate/bivariate statistical maps, and automatically populate the `/output_plots/` directory with 9 finalized `.png` graphs (Histograms, Boxplots, etc).

### 2. Interactive Browser Execution (Jupyter)
Since the PDF requests an interactive cell-by-cell breakdown:
1. Boot up your Anaconda prompt.
2. Type `jupyter notebook`.
3. Open `Experiment_7_Data_Visualization.ipynb`.
4. Hit **Run** on every cell. The `matplotlib inline` configuration will instantly splash the plotted graphs directly onto your web browser underneath your executing blocks exactly as the PDF demonstrated.

## ✨ Univariate Analysis Performed
- **`sns.histplot(df["price"])`**: Computed a frequency curve mapping the concentration distribution of diamond values.
- **`sns.boxplot()`**: Rendered quartile thresholds (Q1, Median, Q3) to easily visually highlight price outliers above the whiskers.
- **`sns.countplot()`**: Evaluated occurrences mapping integer frequency for discrete text variables.

## ✨ Bivariate Analysis Performed
- **`sns.scatterplot()`**: Mapped 2-dimensional `X=Carat` against `Y=Price` arrays highlighting density correlations.
- **`sns.regplot()`**: Sliced 1,000 randomized elements executing a localized linear regression gradient over the variance.
- **`sns.violinplot()`**: Projected probability density estimations grouped distinctly by categorical strings.
