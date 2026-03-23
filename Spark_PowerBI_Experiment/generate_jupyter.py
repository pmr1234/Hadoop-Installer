import nbformat
from nbformat.v4 import new_notebook, new_markdown_cell, new_code_cell

nb = new_notebook()

cells = [
    new_markdown_cell("# Experiment 12: Big Data Processing Pipeline (Power BI)\n**Aim:** Implement an end-to-end Big Data pipeline using Apache Spark to ingest, process, and analyze a real dataset, and visualize the results using Power BI."),
    
    new_markdown_cell("### Step 1: Start Spark Session"),
    new_code_cell("""from pyspark.sql import SparkSession

spark = SparkSession.builder \\
    .appName("BigDataMiniProject") \\
    .getOrCreate()
spark"""),
    
    new_markdown_cell("### Step 2: Data Ingestion (Load NYC Taxi Dataset)"),
    new_code_cell("""df = spark.read.csv(
    "nyc_taxi.csv",
    header=True,
    inferSchema=True
)

df.show(5)"""),
    
    new_markdown_cell("### Step 3: Data Cleaning (Null and Invalid Trips)"),
    new_code_cell("""clean_df = df.dropna()

clean_df = clean_df.filter(
    (clean_df.trip_distance > 0) &
    (clean_df.fare_amount > 0)
)
print("Records cleaned successfully")"""),
    
    new_markdown_cell("### Step 4: Attribute Extraction"),
    new_code_cell("""from pyspark.sql.functions import col

feature_df = clean_df.select(
    col("tpep_pickup_datetime").alias("pickup_datetime"),
    col("tpep_dropoff_datetime").alias("dropoff_datetime"),
    col("passenger_count"),
    col("trip_distance"),
    col("fare_amount"),
    col("payment_type")
)
feature_df.printSchema()"""),
    
    new_markdown_cell("### Step 5: Feature Engineering & Step 6: Data Analytics"),
    new_code_cell("""from pyspark.sql.functions import to_date, avg, count

# Daily Aggregations for Power BI Dashboards
daily_avg_fare = feature_df.withColumn(
    "pickup_date",
    to_date("pickup_datetime")
).groupBy("pickup_date") \\
.agg(
    avg("fare_amount").alias("avg_fare"),
    count("*").alias("total_trips"),
    avg("trip_distance").alias("avg_distance")
)

daily_avg_fare.show(5)"""),
    
    new_markdown_cell("### Step 7: Store Processed Data (Export for Power BI)\nWe convert the grouped Spark DataFrame to a Pandas DataFrame to dump it natively as a single static CSV for Power BI."),
    new_code_cell("""import os

# Create local output directory natively if missing
if not os.path.exists("output"):
    os.makedirs("output", exist_ok=True)

pdf = daily_avg_fare.toPandas()
pdf.to_csv("output/daily_avg_fare.csv", index=False)
print("Data successfully written to output folder (output/daily_avg_fare.csv)")""")
]

nb['cells'] = cells

with open('Experiment_12_BigData_Pipeline.ipynb', 'w') as f:
    nbformat.write(nb, f)

print("[INFO] Jupyter Notebook generated successfully!")
