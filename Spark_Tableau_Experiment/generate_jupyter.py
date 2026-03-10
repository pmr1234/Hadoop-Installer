import nbformat
from nbformat.v4 import new_notebook, new_markdown_cell, new_code_cell

nb = new_notebook()

cells = [
    new_markdown_cell("# Experiment 11: Real-Time Big Data Analytics Pipeline\n**Aim:** To ingest real-time data using Apache Kafka, process it using Spark Structured Streaming, and output CSV data for visualization using Tableau dashboards."),
    
    new_markdown_cell("### Step 1: Configure PySpark and Kafka Dependencies\n> **Note:** We must programmatically inject the `spark-sql-kafka` package here so Spark can natively connect to the Kafka Broker."),
    new_code_cell("""import findspark
import os

# Set required PySpark Kafka packages to stream JSON natively
os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.2 pyspark-shell'

findspark.init()

from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StructType, StructField, IntegerType, FloatType, StringType"""),
    
    new_markdown_cell("### Step 2: Create Spark Session"),
    new_code_cell("""spark = SparkSession.builder \\
    .appName("KafkaSparkStreaming") \\
    .getOrCreate()
    
spark.sparkContext.setLogLevel("WARN")"""),
    
    new_markdown_cell("### Step 3: Define Schema for Incoming JSON Telemetry"),
    new_code_cell("""schema = StructType([
    StructField("sensor_id", IntegerType()),
    StructField("temperature", FloatType()),
    StructField("humidity", FloatType()),
    StructField("timestamp", StringType())
])"""),
    
    new_markdown_cell("### Step 4: Read Data from Kafka Topic"),
    new_code_cell("""df = spark.readStream \\
    .format("kafka") \\
    .option("kafka.bootstrap.servers", "localhost:9092") \\
    .option("subscribe", "sensor-data") \\
    .option("startingOffsets", "latest") \\
    .load()"""),
    
    new_markdown_cell("### Step 5: Parse JSON Data"),
    new_code_cell("""json_df = df.select(
    from_json(col("value").cast("string"), schema).alias("data")
).select("data.*")"""),
    
    new_markdown_cell("### Step 6: Write Stream Output to CSV\nThis continuously extracts the structured dataframe directly into the `output/sensor_data` folder for Tableau absorption."),
    new_code_cell("""query = json_df.writeStream \\
    .outputMode("append") \\
    .format("csv") \\
    .option("path", "output/sensor_data") \\
    .option("checkpointLocation", "checkpoint") \\
    .start()

print("[INFO] PySpark is now actively streaming Kafka data to the output CSV folder!")
print("       You can safely open Tableau now and link it to the CSV files inside 'output/sensor_data'.")
print("       Interrupt the kernel to stop streaming.")

query.awaitTermination()""")
]

nb['cells'] = cells

with open('Experiment_11_SparkStreaming.ipynb', 'w') as f:
    nbformat.write(nb, f)

print("[INFO] Jupyter Notebook generated successfully!")
