import os
import sys

# Windows requires Hadoop winutils for Spark to run locally without HDFS
os.environ['HADOOP_HOME'] = "f:\\hadoop-3.4.2\\hadoop-3.4.2"
sys.path.append("f:\\hadoop-3.4.2\\hadoop-3.4.2\\bin")

from pyspark.sql import SparkSession
from pyspark.ml.clustering import KMeans
from pyspark.ml.feature import VectorAssembler

def main():
    print("\n--- Spark MLlib: K-Means Clustering ---")
    spark = SparkSession.builder.appName("MLlib_Clustering").master("local[*]").getOrCreate()
    spark.sparkContext.setLogLevel("ERROR")

    # 1. Tiny mock dataset (Coordinates)
    data = [(0.1, 0.1), (0.2, 0.2), (9.0, 9.0), (9.1, 9.2)]
    df = spark.createDataFrame(data, ["x", "y"])
    
    # 2. Vectorize features
    assembler = VectorAssembler(inputCols=["x", "y"], outputCol="features")
    dataset = assembler.transform(df).select("features")
    
    # 3. Train Model (K=2)
    kmeans = KMeans(k=2, seed=1)
    model = kmeans.fit(dataset)
    
    # 4. Show Predictions & Centers
    print("\nCluster Assignments:")
    model.transform(dataset).show()
    
    print("\nCalculated Centroids:")
    for center in model.clusterCenters():
        print(center)
        
    spark.stop()

if __name__ == "__main__":
    main()
