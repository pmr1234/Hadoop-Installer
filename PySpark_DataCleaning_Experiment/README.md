# PySpark Data Cleaning and Transformation

This folder implements **Experiment 4: Data cleaning and transformation using PySpark DataFrames** as specified in the assignment PDF.

## 📦 How to Clone this Specific Experiment
To prevent different experiments from getting mixed up, this repository is organized using Git Tags. You can download *only* this exact PySpark experiment code by running:
```bash
git clone --branch v4.0-pyspark https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
Data cleaning and transformation are important steps in Big Data Analytics. Raw data often contains missing values, duplicate records, incorrect formats, and inconsistent entries. PySpark provides a powerful DataFrame API backed by lazy evaluation and DAG optimization to rapidly prepare massive datasets.

This experiment demonstrates handling null properties inside `salary` and `age` fields via PySpark DataFrame methods like `fillna`, `withColumn`, `select`, `filter`, and `groupBy`.

---

## 🚀 How to Run (Two Options!)

We have provided two identical versions of the experiment depending on your environment preference:

### Option 1: Fully Automated Terminal Script
If you want to just instantly run the PySpark code in your terminal without launching a web browser:
1. Ensure `Hadoop` and `Java` are active.
2. Double-click the wrapper:
   ```bat
   run_pyspark.cmd
   ```
This dynamically sets up `JAVA_HOME`, bridges `pyspark` to Hadoop `winutils.exe`, and prints out every dataset frame directly into the command prompt.

### Option 2: Jupyter Notebook
If you want to view the traditional interactive cell-based lab report requested in the PDF:
1. Open your Anaconda Prompt or Command Prompt.
2. Type `jupyter notebook`
3. A browser window will open. Navigate to the `PySpark_DataCleaning_Experiment` folder and click on **`Experiment_4_DataCleaning.ipynb`**.
4. You can run each cell individually by clicking **Run**!

## ✨ Key Operations Used
- `df.fillna()`: Dynamically cleans null variables.
- `df.select()`: Subsets specific columns for targeting isolated analytics.
- `df.withColumn()`: Multiplies rows together to construct new feature tables.
- `df.withColumnRenamed()`: Adjusts internal schema labels mapping strings to business needs.
- `df.orderBy()`: Computes dataset clustering rankings.
