import nbformat
from nbformat.v4 import new_notebook, new_markdown_cell, new_code_cell

nb = new_notebook()

cells = [
    new_markdown_cell("# Experiment 9: Exploratory Data Analysis (EDA) and Feature Analysis\n**Aim:** To perform Exploratory Data Analysis (EDA) on a dataset using Pandas and Seaborn to understand relationships, distributions, and feature logic."),
    
    new_markdown_cell("### Step 1 & 2: Import Libraries and Load Dataset"),
    new_code_cell("import pandas as pd\nimport numpy as np\nimport matplotlib.pyplot as plt\nimport seaborn as sns\nfrom sklearn.datasets import load_iris\n\niris = load_iris()\ndf = pd.DataFrame(iris.data, columns=iris.feature_names)\n\ndf['species'] = iris.target\ndf['species'] = df['species'].map({\n    0: 'Setosa',\n    1: 'Versicolor',\n    2: 'Virginica'\n})"),
    
    new_markdown_cell("### Step 3: Dataset Information"),
    new_code_cell("df.head()"),
    new_code_cell("df.info()"),
    
    new_markdown_cell("### Step 4 & 5: Statistical Summary & Check Missing Values"),
    new_code_cell("df.describe()"),
    new_code_cell("df.isnull().sum()"),
    
    new_markdown_cell("### Step 6: Univariate Analysis (Histogram)"),
    new_code_cell("plt.figure(figsize=(6,4))\ndf['sepal length (cm)'].hist(bins=20)\nplt.title(\"Sepal Length Distribution\")\nplt.xlabel(\"Sepal Length (cm)\")\nplt.ylabel(\"Frequency\")\nplt.show()"),
    
    new_markdown_cell("### Step 7: Univariate Analysis (Box Plot)"),
    new_code_cell("plt.figure(figsize=(6,4))\nsns.boxplot(x=df['petal length (cm)'])\nplt.title(\"Petal Length Box Plot\")\nplt.show()"),
    
    new_markdown_cell("### Step 8: Multivariate Analysis (Pair Plot)"),
    new_code_cell("sns.pairplot(df, hue='species')\nplt.show()"),
    
    new_markdown_cell("### Step 9: Feature Analysis (Correlation Heatmap)"),
    new_code_cell("plt.figure(figsize=(8,6))\nsns.heatmap(\n    df.drop('species', axis=1).corr(),\n    annot=True,\n    cmap='coolwarm'\n)\nplt.title(\"Correlation Heatmap\")\nplt.show()")
]

nb['cells'] = cells

with open('Experiment_9_EDA.ipynb', 'w') as f:
    nbformat.write(nb, f)

print("[INFO] Jupyter Notebook generated successfully!")
