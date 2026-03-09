from pyspark.sql import SparkSession
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.evaluation import BinaryClassificationEvaluator
from pyspark.ml.clustering import KMeans

import os
import sys

# Set JAVA_HOME explicitly
os.environ["JAVA_HOME"] = r"C:\Program Files\Eclipse Adoptium\jdk-11.0.29.7-hotspot"
os.environ["HADOOP_HOME"] = r"C:\hadoop"

# Step 1: Create Spark Session
spark = SparkSession.builder \
    .appName("MLlib_Classification_Clustering") \
    .config("spark.sql.warehouse.dir", os.path.join(os.getcwd(), "warehouse")) \
    .config("spark.driver.host", "localhost") \
    .config("spark.driver.extraJavaOptions", "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED") \
    .getOrCreate()

print("Experiment - 1: Classification using Logistic Regression")
# Step 2: Load Dataset
data = spark.read.csv("data.csv", header=True, inferSchema=True)
data.show(5)

# Step 3: Feature Vectorization
assembler = VectorAssembler(
    inputCols=["age", "salary"],  # Explicitly naming columns based on known schema from data.csv
    outputCol="features"
)

final_data = assembler.transform(data)
final_data = final_data.select("features", "label")

# Step 4: Split Dataset
train_data, test_data = final_data.randomSplit([0.7, 0.3], seed=42)

# Step 5: Train Logistic Regression Model
lr = LogisticRegression(featuresCol="features", labelCol="label")
model = lr.fit(train_data)

# Step 6: Predictions
predictions = model.transform(test_data)
predictions.select("label", "prediction").show()

# Step 7: Model Evaluation
evaluator = BinaryClassificationEvaluator()
accuracy = evaluator.evaluate(predictions)
print("Accuracy:", accuracy)

print("-" * 50)
print("Experiment - 2: Clustering using K-Means")

# Step 2: Load Dataset
data_cluster = spark.read.csv("cluster_data.csv", header=True, inferSchema=True)
data_cluster.show()

# Step 3: Vector Assembler
assembler_cluster = VectorAssembler(
    inputCols=["x", "y"], # Explicitly naming columns based on known schema from cluster_data.csv
    outputCol="features"
)

final_data_cluster = assembler_cluster.transform(data_cluster)

# Step 4: Apply K-Means
kmeans = KMeans(k=3, seed=1)
model_kmeans = kmeans.fit(final_data_cluster)

# Step 5: Predictions
predictions_cluster = model_kmeans.transform(final_data_cluster)
predictions_cluster.select("features", "prediction").show()

# Step 6: Cluster Centers
centers = model_kmeans.clusterCenters()
print("Cluster Centers:")
for center in centers:
    print(center)

spark.stop()
