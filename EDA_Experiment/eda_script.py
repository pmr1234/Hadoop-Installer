import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_iris

print("===========================================")
print(" Running Experiment 9: EDA on Iris Dataset")
print("===========================================")

# Ensure output directory exists for headless plotting
output_dir = "output_plots"
os.makedirs(output_dir, exist_ok=True)

# 1. Load the Dataset
print("\n[INFO] Loading Iris Dataset from sklearn...")
iris = load_iris()
df = pd.DataFrame(iris.data, columns=iris.feature_names)

# Map target categorical values
df['species'] = iris.target
df['species'] = df['species'].map({
    0: 'Setosa',
    1: 'Versicolor',
    2: 'Virginica'
})

# 2. Terminal Informational Analytics (Text)
print("\n--- DataFrame Head (Sample) ---")
print(df.head())

print("\n--- DataFrame Info ---")
df.info()

print("\n--- Statistical Summary ---")
print(df.describe())

print("\n--- Missing Value Check ---")
print(df.isnull().sum())


# 3. Data Visualization (Exporting to Disk)
print("\n[INFO] Background generating Matplotlib and Seaborn analytics...")

# Univariate Analysis: Histogram
print("\n-> Generating Sepal Length Distribution (Histogram)...")
plt.figure(figsize=(6,4))
df['sepal length (cm)'].hist(bins=20)
plt.title("Sepal Length Distribution")
plt.xlabel("Sepal Length (cm)")
plt.ylabel("Frequency")
plt.savefig(f"{output_dir}/1_sepal_length_histogram.png")
plt.close()

# Univariate Analysis: Boxplot
print("-> Generating Petal Length Spread (Box Plot)...")
plt.figure(figsize=(6,4))
sns.boxplot(x=df['petal length (cm)'])
plt.title("Petal Length Box Plot")
plt.savefig(f"{output_dir}/2_petal_length_boxplot.png")
plt.close()

# Bivariate / Multivariate Analysis: Pairplot
print("-> Generating Multivariate Pairplot...")
sns.pairplot(df, hue='species')
plt.savefig(f"{output_dir}/3_multivariate_pairplot.png")
plt.close()

# Feature Analysis: Correlation Heatmap
print("-> Generating Feature Correlation (Heatmap)...")
plt.figure(figsize=(8,6))
# Need to drop the non-numeric 'species' column before calculating the correlation matrix
sns.heatmap(
    df.drop('species', axis=1).corr(),
    annot=True,
    cmap='coolwarm'
)
plt.title("Correlation Heatmap")
plt.savefig(f"{output_dir}/4_correlation_heatmap.png")
plt.close()

print(f"\n[SUCCESS] EDA complete. 4 output graphs successfully dumped cleanly to \\{output_dir}\\.")
