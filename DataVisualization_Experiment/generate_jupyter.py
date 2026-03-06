import nbformat
from nbformat.v4 import new_notebook, new_markdown_cell, new_code_cell

nb = new_notebook()

cells = [
    new_markdown_cell("# Experiment 7: Data Visualization using Matplotlib and Seaborn\n**Aim:** To visualize data using Matplotlib and Seaborn libraries in Python and perform univariate and bivariate analysis."),
    new_markdown_cell("### Step 5: Import Required Libraries"),
    new_code_cell("import numpy as np\nimport pandas as pd\nimport matplotlib.pyplot as plt\nimport seaborn as sns\n%matplotlib inline"),
    new_markdown_cell("### Step 6: Load Dataset\nWe use Seaborn's built-in `diamonds` dataset."),
    new_code_cell("df = sns.load_dataset(\"diamonds\")\ndf.head()"),
    new_markdown_cell("### Step 7: Univariate Analysis\n#### 7.1 Histogram"),
    new_code_cell("sns.histplot(df[\"price\"], kde=True)\nplt.title(\"Distribution of Diamond Prices\")\nplt.show()"),
    new_markdown_cell("#### 7.2 Boxplot - Univariate"),
    new_code_cell("sns.boxplot(y=df[\"price\"])\nplt.title(\"Boxplot of Diamond Prices\")\nplt.show()"),
    new_markdown_cell("#### 7.3 Countplot"),
    new_code_cell("sns.countplot(x=\"cut\", data=df)\nplt.title(\"Count of Diamond Cuts\")\nplt.show()"),
    new_markdown_cell("#### 7.4 Scatterplot"),
    new_code_cell("sns.scatterplot(x=\"carat\", y=\"price\", data=df)\nplt.title(\"Carat vs Price\")\nplt.show()"),
    new_markdown_cell("#### 7.5 Regplot"),
    new_code_cell("sns.regplot(x=\"carat\", y=\"price\", data=df.sample(1000, random_state=42), scatter_kws={'alpha':0.5})\nplt.title(\"Regression: Carat vs Price\")\nplt.show()"),
    new_markdown_cell("### Step 8: Bivariate Analysis\n#### 8.1 Boxplot Bivariant"),
    new_code_cell("sns.boxplot(x=\"cut\", y=\"price\", data=df)\nplt.title(\"Price by Cut\")\nplt.show()"),
    new_markdown_cell("#### 8.2 Violinplot"),
    new_code_cell("sns.violinplot(x=\"cut\", y=\"price\", data=df)\nplt.title(\"Price Distribution by Cut\")\nplt.show()"),
    new_markdown_cell("#### 8.3 Histplot-Seaborn"),
    new_code_cell("sns.histplot(df['price'], bins=10, kde=True)\nplt.title(\"Histogram of Diamond Price using Seaborn\")\nplt.xlabel(\"Price\")\nplt.ylabel(\"Frequency\")\nplt.show()"),
    new_markdown_cell("#### 8.4 Lineplot"),
    new_code_cell("sns.lineplot(x='carat', y='price', data=df)\nplt.title(\"Line Plot of Carat vs Price\")\nplt.xlabel(\"Carat\")\nplt.ylabel(\"Price\")\nplt.show()")
]

nb['cells'] = cells

with open('Experiment_7_Data_Visualization.ipynb', 'w') as f:
    nbformat.write(nb, f)

print("[INFO] Jupyter Notebook generated successfully!")
