import nbformat
from nbformat.v4 import new_notebook, new_markdown_cell, new_code_cell

nb = new_notebook()

cells = [
    new_markdown_cell("# Experiment 4: Data Cleaning and Transformation using PySpark DataFrames\n**Aim:** To Implement Data cleaning and transformation using PySpark DataFrames."),
    new_markdown_cell("### Step 6: Initialize PySpark in Jupyter\nWe use `findspark` to automatically link the Python environment with the PySpark libraries."),
    new_code_cell("import findspark\nfindspark.init()"),
    new_markdown_cell("### Step 7: Create SparkSession\nInitialize the Spark engine and UI port."),
    new_code_cell("from pyspark.sql import SparkSession\n\nspark = SparkSession.builder \\\n    .appName(\"DataCleaningLab\") \\\n    .config(\"spark.ui.port\", \"4050\") \\\n    .getOrCreate()\n\nspark"),
    new_markdown_cell("### Step 8: Run Data Cleaning Program\nCreate the initial DataFrame containing mock values, specifically including `None` elements to simulate missing data."),
    new_code_cell("data = [\n    (1, \"AJITH Goud\", 25, \"Bangalore\", 50000),\n    (2, \"JITHENDRA\", None, \"Hyderabad\", 45000),\n    (3, \"HESHWANTH\", 28, None, None),\n    (4, \"VISHNU\", 35, \"Chennai\", 70000),\n    (5, \"MAHESH\", 40, None, 40000)\n]\n\ncolumns = [\"id\", \"name\", \"age\", \"city\", \"salary\"]\n\ndf = spark.createDataFrame(data, columns)\ndf.show()"),
    new_markdown_cell("### Step 9: Perform Data Cleaning\nUse `fillna` to dynamically clean up missing inputs across different columns, swapping `None` for integer `0` or string `'Unknown'`."),
    new_code_cell("df_clean = df.fillna({\n    \"age\": 0,\n    \"city\": \"Unknown\",\n    \"salary\": 0\n})\ndf_clean.show()"),
    new_markdown_cell("### Step 10: Data Transformation Operations\n#### 11.1 Select Specific Columns"),
    new_code_cell("df_select = df_clean.select(\"name\", \"salary\")\ndf_select.show()"),
    new_markdown_cell("#### 11.2 Filter Rows (Salary > 40000)"),
    new_code_cell("df_filter = df_clean.filter(df_clean.salary > 40000)\ndf_filter.show()"),
    new_markdown_cell("#### 11.3 Create New Column (Annual Salary)\nApply an arithmetic multiplier to the `salary` column to generate a new feature column."),
    new_code_cell("from pyspark.sql.functions import col\n\ndf_new = df_clean.withColumn(\"annual_salary\", col(\"salary\") * 12)\ndf_new.show()"),
    new_markdown_cell("#### 11.4 Rename Column"),
    new_code_cell("df_rename = df_new.withColumnRenamed(\"name\", \"employee_name\")\ndf_rename.show()"),
    new_markdown_cell("#### 11.5 Sort Data (Descending Salary)"),
    new_code_cell("df_sort = df_rename.orderBy(df_rename.salary.desc())\ndf_sort.show()"),
    new_markdown_cell("#### 11.6 Group By and Aggregation (City-wise Average Salary)"),
    new_code_cell("from pyspark.sql.functions import avg\n\ndf_group = df_rename.groupBy(\"city\").agg(avg(\"salary\").alias(\"avg_salary\"))\ndf_group.show()"),
    new_markdown_cell("### Step 11: Stop Spark Session (Important)\nAlways stop the Spark Session to gracefully release the Hadoop JVM resources."),
    new_code_cell("spark.stop()")
]

nb['cells'] = cells

with open('Experiment_4_DataCleaning.ipynb', 'w') as f:
    nbformat.write(nb, f)

print("[INFO] Jupyter Notebook generated successfully!")
