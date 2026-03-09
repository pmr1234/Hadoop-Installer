import os
import sys
from pyspark.sql import SparkSession

# Set JAVA_HOME explicitly
os.environ["JAVA_HOME"] = r"C:\Program Files\Java\jdk-21"

try:
    # Configure Spark to be more resilient on Windows without winutils and with Java 21
    spark = SparkSession.builder \
        .appName("SimpleTest") \
        .config("spark.sql.warehouse.dir", os.path.join(os.getcwd(), "warehouse")) \
        .config("spark.driver.host", "localhost") \
        .config("spark.driver.extraJavaOptions", "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED") \
        .getOrCreate()
    print("Spark session created")
    data = [("Alice", 1)]
    df = spark.createDataFrame(data)
    df.show()
    print("DataFrame shown")
    spark.stop()
except Exception as e:
    print(f"Error: {e}")
