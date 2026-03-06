import findspark
findspark.init()

from pyspark.sql import SparkSession

print("=========================================")
print("  Experiment 6: PySpark + MongoDB Tests  ")
print("=========================================")

# Step 8: Create Spark Session with MongoDB Connector
try:
    spark = SparkSession.builder \
        .appName("SparkMongoDemo") \
        .config("spark.jars.packages", "org.mongodb.spark:mongo-spark-connector_2.12:3.0.1") \
        .config("spark.mongodb.output.uri", "mongodb://127.0.0.1:27017/sparkdb.employee") \
        .config("spark.mongodb.input.uri", "mongodb://127.0.0.1:27017/sparkdb.employee") \
        .config("spark.ui.port", "4050") \
        .getOrCreate()
    print("\n[SUCCESS] Spark connected successfully to MongoDB!\n")
except Exception as e:
    print(f"\n[FATAL ERROR] Failed to initialize SparkSession with MongoDB: {e}")
    exit(1)

# Step 9: Create DataFrame and Insert Data
data = [
    (1, "Ravi", "IT", 40000),
    (2, "Sita", "HR", 35000),
    (3, "Kiran", "Finance", 48000)
]
columns = ["empid", "name", "dept", "salary"]

print("--- Data to Insert ---")
df = spark.createDataFrame(data, columns)
df.show()

print("\n--- Writing Data to MongoDB ---")
try:
    df.write.format("mongo").mode("append").save()
    print("\n[SUCCESS] Data successfully inserted into MongoDB!\n")
except Exception as e:
    print(f"\n[ERROR] Failed to write data: {e}")

# Read the data back to verify
print("--- Reading Data Back from MongoDB to Verify Insertion ---")
try:
    df_read = spark.read.format("mongo").load()
    df_read.show()
except Exception as e:
    print(f"\n[ERROR] Failed to read data: {e}")

spark.stop()
print("\n[SUCCESS] SparkSession Stopped safely.")
