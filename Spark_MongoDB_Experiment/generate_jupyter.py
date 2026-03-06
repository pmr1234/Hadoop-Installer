import nbformat
from nbformat.v4 import new_notebook, new_markdown_cell, new_code_cell

nb = new_notebook()

cells = [
    new_markdown_cell("# Experiment 6: Connecting Spark with MongoDB\n**Aim:** To install Apache Spark and connect it with MongoDB to perform Big Data processing."),
    new_markdown_cell("### Step 6 & 7: Initialize PySpark in Jupyter\nWe use `findspark` to link with the PySpark libraries."),
    new_code_cell("import findspark\nfindspark.init()"),
    new_markdown_cell("### Step 8: Create Spark Session with MongoDB Connector\nWe initialize the Spark session and pass the MongoDB Spark Connector as a configuration package."),
    new_code_cell("from pyspark.sql import SparkSession\n\ntry:\n    spark = SparkSession.builder \\\n        .appName(\"SparkMongoDemo\") \\\n        .config(\"spark.jars.packages\", \"org.mongodb.spark:mongo-spark-connector_2.12:3.0.1\") \\\n        .config(\"spark.mongodb.output.uri\", \"mongodb://127.0.0.1:27017/sparkdb.employee\") \\\n        .config(\"spark.mongodb.input.uri\", \"mongodb://127.0.0.1:27017/sparkdb.employee\") \\\n        .config(\"spark.ui.port\", \"4050\") \\\n        .getOrCreate()\n    print(\"Spark connected successfully\")\nexcept Exception as e:\n    print(f\"Failed to connect to Spark: {e}\")"),
    new_markdown_cell("### Step 9: Create DataFrame and Insert Data\nCreate a subset of mock structured employee data and insert it seamlessly into our NoSQL database natively using DataFrame writes."),
    new_code_cell("data = [\n    (1, \"Ravi\", \"IT\", 40000),\n    (2, \"Sita\", \"HR\", 35000),\n    (3, \"Kiran\", \"Finance\", 48000)\n]\ncolumns = [\"empid\", \"name\", \"dept\", \"salary\"]\n\ndf = spark.createDataFrame(data, columns)\ndf.show()"),
    new_markdown_cell("Write DataFrame directly back to MongoDB using `df.write.format(\"mongo\")`."),
    new_code_cell("try:\n    df.write.format(\"mongo\").mode(\"append\").save()\n    print(\"Data successfully inserted into MongoDB\")\nexcept Exception as e:\n    print(f\"Error: {e}\")"),
    new_markdown_cell("### Verification: Read Data Back from MongoDB"),
    new_code_cell("df_read = spark.read.format(\"mongo\").load()\ndf_read.show()"),
    new_markdown_cell("### Cleanup"),
    new_code_cell("spark.stop()")
]

nb['cells'] = cells

with open('Experiment_6_Spark_MongoDB.ipynb', 'w') as f:
    nbformat.write(nb, f)

print("[INFO] Jupyter Notebook generated successfully!")
