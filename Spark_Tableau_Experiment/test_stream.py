import findspark
import os
import time

# Set required PySpark Kafka packages to stream JSON natively
os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.2 pyspark-shell'
findspark.init()

from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StructType, StructField, IntegerType, FloatType, StringType

print("[INFO] Booting Headless PySpark Consumer...")
spark = SparkSession.builder \
    .appName("KafkaSparkStreaming-Headless-Test") \
    .getOrCreate()
spark.sparkContext.setLogLevel("WARN")

schema = StructType([
    StructField("sensor_id", IntegerType()),
    StructField("temperature", FloatType()),
    StructField("humidity", FloatType()),
    StructField("timestamp", StringType())
])

print("[INFO] Connecting to Kafka localhost:9092...")
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "sensor-data") \
    .option("startingOffsets", "latest") \
    .load()

json_df = df.select(
    from_json(col("value").cast("string"), schema).alias("data")
).select("data.*")

print("[INFO] Writing Stream Output to output/sensor_data/ CSV folder...")
query = json_df.writeStream \
    .outputMode("append") \
    .format("csv") \
    .option("path", "output/sensor_data") \
    .option("checkpointLocation", "checkpoint") \
    .start()

# Let the PySpark stream run for exactly 15 seconds to cache a few CSV chunks
time.sleep(15)
query.stop()
print("[SUCCESS] Headless Spark execution completed properly. Check the 'output' folder!")
