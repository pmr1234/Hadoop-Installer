from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_date, avg
import os

print("=========================================================")
print("  Experiment 12: Big Data Processing Pipeline")
print("=========================================================")

# Ensure C:/temp geometry exists
OUTPUT_DIR = "C:/temp"
if not os.path.exists(OUTPUT_DIR):
    print(f"[INFO] Creating output directory at {OUTPUT_DIR}...")
    try:
        os.makedirs(OUTPUT_DIR)
    except PermissionError:
        print(f"[WARN] Failed to create {OUTPUT_DIR} due to permissions. Defaulting to local ./temp folder.")
        OUTPUT_DIR = "./temp"
        os.makedirs(OUTPUT_DIR, exist_ok=True)

OUTPUT_FILE = f"{OUTPUT_DIR}/daily_avg_fare.csv"

# 1. Environment Setup
print("\n[1/7] Initializing PySpark JVM Context...")
spark = SparkSession.builder \
    .appName("BigDataMiniProject_Headless") \
    .getOrCreate()
spark.sparkContext.setLogLevel("WARN")

# 2. Data Ingestion
print("\n[2/7] Ingesting NYC Taxi CSV Array...")
df = spark.read.csv("nyc_taxi.csv", header=True, inferSchema=True)
print("-> Head Sample:")
df.show(5)

# 3. Data Cleaning
print("\n[3/7] Filtering Invalid Elements (Negatives/Nulls)...")
clean_df = df.dropna()
clean_df = clean_df.filter(
    (clean_df.trip_distance > 0) & 
    (clean_df.fare_amount > 0)
)
print("-> Cleaned Dataset Structure:")
clean_df.show(3)

# 4. Attribute Extraction
print("\n[4/7] Generating Feature Aliases...")
feature_df = clean_df.select(
    col("tpep_pickup_datetime").alias("pickup_datetime"),
    col("tpep_dropoff_datetime").alias("dropoff_datetime"),
    col("passenger_count"),
    col("trip_distance"),
    col("fare_amount"),
    col("payment_type")
)
feature_df.printSchema()

# 5. Feature Engineering / Data Analytics
print("\n[5/7] Grouping Daily Fare Aggregations...")
daily_avg_fare = feature_df.withColumn(
    "pickup_date",
    to_date("pickup_datetime")
).groupBy("pickup_date") \
.agg(avg("fare_amount").alias("avg_fare"))

print("-> Aggregation Results:")
daily_avg_fare.show(5)

# 6. Store Processed Data
print(f"\n[6/7] Exporting Final Analytics to Pandas: {OUTPUT_FILE}")
try:
    pdf = daily_avg_fare.toPandas()
    pdf.to_csv(OUTPUT_FILE, index=False)
    print(f"[SUCCESS] CSV Artifact correctly dumped for Power BI to {OUTPUT_FILE}!")
except Exception as e:
    print(f"[ERROR] Pandas failed to write to {OUTPUT_FILE}: {e}")

print("\n[7/7] PySpark Driver Exited Successfully.")
spark.stop()
