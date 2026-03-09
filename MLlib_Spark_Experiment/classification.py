import os
import sys

# Windows requires Hadoop winutils for Spark to run locally without HDFS
os.environ['HADOOP_HOME'] = "f:\\hadoop-3.4.2\\hadoop-3.4.2"
sys.path.append("f:\\hadoop-3.4.2\\hadoop-3.4.2\\bin")

from pyspark.sql import SparkSession
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.feature import VectorAssembler

def main():
    print("\n--- Spark MLlib: Logistic Regression ---")
    spark = SparkSession.builder.appName("MLlib_Classification").master("local[*]").getOrCreate()
    spark.sparkContext.setLogLevel("ERROR")

    # 1. Very small mock dataset: [Label(0=Fail, 1=Pass), HoursStudied]
    data = [(0.0, 1.0), (0.0, 2.0), (1.0, 8.0), (1.0, 9.0)]
    df = spark.createDataFrame(data, ["label", "hours"])
    
    # 2. Vectorize feature
    assembler = VectorAssembler(inputCols=["hours"], outputCol="features")
    dataset = assembler.transform(df).select("label", "features")
    
    # 3. Train Model
    lr = LogisticRegression(maxIter=10)
    model = lr.fit(dataset)
    
    # 4. Show Predictions
    print("\nModel Predictions:")
    model.transform(dataset).select("features", "label", "prediction").show()
    
    spark.stop()

if __name__ == "__main__":
    main()
