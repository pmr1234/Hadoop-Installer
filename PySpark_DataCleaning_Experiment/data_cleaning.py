import findspark
findspark.init()

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, avg

print("=========================================")
print("      PySpark Experiment 4 Execution     ")
print("=========================================")

# Step 7: Create SparkSession
try:
    spark = SparkSession.builder \
        .appName("DataCleaningLab") \
        .config("spark.ui.port", "4050") \
        .getOrCreate()
    print("\n[SUCCESS] SparkSession Initialized!\n")
except Exception as e:
    print(f"\n[FATAL ERROR] Failed to initialize SparkSession: {e}")
    exit(1)

# Step 8: Run Data Cleaning Program
data = [
    (1, "AJITH Goud", 25, "Bangalore", 50000),
    (2, "JITHENDRA", None, "Hyderabad", 45000),
    (3, "HESHWANTH", 28, None, None),
    (4, "VISHNU", 35, "Chennai", 70000),
    (5, "MAHESH", 40, None, 40000)
]

columns = ["id", "name", "age", "city", "salary"]

print("--- Original DataFrame ---")
df = spark.createDataFrame(data, columns)
df.show()

# Step 9: Perform Data Cleaning
print("--- After Data Cleaning (fillna) ---")
df_clean = df.fillna({
    "age": 0,
    "city": "Unknown",
    "salary": 0
})
df_clean.show()

# Step 10: Data Transformation Operations
print("--- 11.1 Select Specific Columns ---")
df_select = df_clean.select("name", "salary")
df_select.show()

print("--- 11.2 Filter Rows (Salary > 40000) ---")
df_filter = df_clean.filter(df_clean.salary > 40000)
df_filter.show()

print("--- 11.3 Create New Column (Annual Salary) ---")
df_new = df_clean.withColumn("annual_salary", col("salary") * 12)
df_new.show()

print("--- 11.4 Rename Column ---")
df_rename = df_new.withColumnRenamed("name", "employee_name")
df_rename.show()

print("--- 11.5 Sort Data (Descending Salary) ---")
df_sort = df_rename.orderBy(df_rename.salary.desc())
df_sort.show()

print("--- 11.6 Group By and Aggregation (City-wise Average Salary) ---")
df_group = df_rename.groupBy("city").agg(avg("salary").alias("avg_salary"))
df_group.show()

# Step 11: Stop Spark Session (Important)
spark.stop()
print("\n[SUCCESS] SparkSession Stopped safely.")
