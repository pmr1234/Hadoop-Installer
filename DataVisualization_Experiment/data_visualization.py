import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Ensure output directory exists
output_dir = "output_plots"
os.makedirs(output_dir, exist_ok=True)

print("Loading 'diamonds' dataset...")
df = sns.load_dataset("diamonds")

print("Generating 7.1 Histogram...")
plt.figure()
sns.histplot(df["price"], kde=True)
plt.title("Distribution of Diamond Prices")
plt.savefig(f"{output_dir}/7.1_histogram.png")
plt.close()

print("Generating 7.2 Boxplot - Univariate...")
plt.figure()
sns.boxplot(y=df["price"])
plt.title("Boxplot of Diamond Prices")
plt.savefig(f"{output_dir}/7.2_boxplot_univariate.png")
plt.close()

print("Generating 7.3 Countplot...")
plt.figure()
sns.countplot(x="cut", data=df)
plt.title("Count of Diamond Cuts")
plt.savefig(f"{output_dir}/7.3_countplot.png")
plt.close()

print("Generating 7.4 Scatterplot...")
plt.figure()
sns.scatterplot(x="carat", y="price", data=df)
plt.title("Carat vs Price")
plt.savefig(f"{output_dir}/7.4_scatterplot.png")
plt.close()

print("Generating 7.5 Regplot...")
plt.figure()
# Sample data for regplot to speed it up if it takes too long, but let's try full dataset first.
# Seaborn regplot on 50k points might be slow, sampling a subset:
sns.regplot(x="carat", y="price", data=df.sample(1000, random_state=42), scatter_kws={'alpha': 0.5})
plt.title("Regression: Carat vs Price (Sampled)")
plt.savefig(f"{output_dir}/7.5_regplot.png")
plt.close()

print("Generating 8.1 Boxplot Bivariant...")
plt.figure()
sns.boxplot(x="cut", y="price", data=df)
plt.title("Price by Cut")
plt.savefig(f"{output_dir}/8.1_boxplot_bivariant.png")
plt.close()

print("Generating 8.2 Violinplot...")
plt.figure()
sns.violinplot(x="cut", y="price", data=df)
plt.title("Price Distribution by Cut")
plt.savefig(f"{output_dir}/8.2_violinplot.png")
plt.close()

print("Generating 8.3 Histplot-Seaborn...")
plt.figure()
sns.histplot(df['price'], bins=10, kde=True)
plt.title("Histogram of Diamond Price using Seaborn")
plt.xlabel("Price")
plt.ylabel("Frequency")
plt.savefig(f"{output_dir}/8.3_histplot.png")
plt.close()

print("Generating 8.4 Lineplot...")
plt.figure()
# Lineplot can also be slow on 54k rows without aggregation. Seaborn handles aggregation by default.
sns.lineplot(x='carat', y='price', data=df)
plt.title("Line Plot of Carat vs Price")
plt.xlabel("Carat")
plt.ylabel("Price")
plt.savefig(f"{output_dir}/8.4_lineplot.png")
plt.close()

print(f"All visualizations successfully generated and saved to {output_dir}/")
