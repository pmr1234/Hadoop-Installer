from pyspark.sql import SparkSession
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.feature import VectorAssembler
from pyspark.sql import Row
from pyspark.ml.clustering import KMeans

import os
import sys

# Set JAVA_HOME explicitly
os.environ["JAVA_HOME"] = r"C:\Program Files\Eclipse Adoptium\jdk-11.0.29.7-hotspot"
os.environ["HADOOP_HOME"] = r"C:\hadoop"

# Initialize Spark Session
spark = SparkSession.builder \
    .appName("MLlib_Lab_Solution_A") \
    .config("spark.sql.warehouse.dir", os.path.join(os.getcwd(), "warehouse")) \
    .config("spark.driver.host", "localhost") \
    .config("spark.driver.extraJavaOptions", "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED") \
    .getOrCreate()

print("Experiment - A: Classification using Logistic Regression")
# Create Sample Data
data = [
    Row(age=22, salary=20000, label=0),
    Row(age=25, salary=25000, label=0),
    Row(age=35, salary=50000, label=1),
    Row(age=45, salary=80000, label=1)
]

df = spark.createDataFrame(data)
df.show()

# Feature Vectorization
assembler = VectorAssembler(
    inputCols=["age", "salary"],
    outputCol="features"
)

final_data = assembler.transform(df)
final_data.show()

# Model Training
lr = LogisticRegression(featuresCol="features", labelCol="label")
model = lr.fit(final_data)

# Prediction
predictions = model.transform(final_data)
predictions.select("age", "salary", "label", "prediction").show()

print("-" * 50)
print("Experiment - B: Clustering using K-Means Algorithm")

# Create Sample Dataset
data_kmeans = [
    (1.0, 1.0),
    (1.5, 2.0),
    (3.0, 4.0),
    (5.0, 7.0),
    (3.5, 5.0),
    (4.5, 5.0),
    (3.5, 4.5)
]

columns = ["x", "y"]
df_kmeans = spark.createDataFrame(data_kmeans, columns)
df_kmeans.show()

# Convert to Feature Vector
assembler_kmeans = VectorAssembler(
    inputCols=["x", "y"],
    outputCol="features"
)

final_df_kmeans = assembler_kmeans.transform(df_kmeans)
final_df_kmeans.show()

# Apply K-Means
kmeans = KMeans(k=2, seed=1)
model_kmeans = kmeans.fit(final_df_kmeans)

# Predict Clusters
predictions_kmeans = model_kmeans.transform(final_df_kmeans)
predictions_kmeans.select("x", "y", "prediction").show()

# Cluster Centers
centers = model_kmeans.clusterCenters()
print("Cluster Centers:")
for center in centers:
    print(center)

spark.stop()
