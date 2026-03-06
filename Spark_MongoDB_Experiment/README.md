# Connecting Spark with MongoDB

This folder implements **Experiment 6: Installation and configuration of Apache Spark and integration with MongoDB for NoSQL-based Big Data Processing.**

## 📦 How to Clone this Specific Experiment
To prevent different experiments from getting mixed up, this repository is organized using Git Tags. You can download *only* this exact PySpark-MongoDB experiment code by running:
```bash
git clone --branch v6.0-spark-mongo https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
Apache Spark is a lightning-fast distributed computing framework. MongoDB is a high-performance NoSQL document-oriented database. The **MongoDB Spark Connector** enables Apache Spark to seamlessly natively inject or extract data structures directly from MongoDB instances, enabling scalable analytics on large JSON-structured datasets.

In this experiment, we initialize PySpark via Python, dynamically ingest the `org.mongodb.spark:mongo-spark-connector_2.12:3.0.1` package directly from Maven Central, convert a PySpark mock data frame into JSON objects, and assert them onto a local MongoDB daemon instance (`mongod`).

---

## 🚀 How to Run

Normally, running MongoDB and PySpark on Windows requires orchestrating several different background terminal windows. We have constructed a fully automated environment for you:

### 1. Auto-Install MongoDB
If you do not have MongoDB Community Server explicitly installed on your computer, run:
```bat
auto_install_mongo.cmd
```
*This precisely downloads the official `mongodb-windows-x86_64-7.0.14` archive and safely extracts a portable sandboxed NoSQL database on your machine without modifying your Windows Registry.*

### 2. Execute PySpark Experiment (Terminal)
Ensure you have `Hadoop` and `Java` properly scoped, then double-click:
```bat
run_spark_mongo.cmd
```
*This master orchestration script automatically launches the NoSQL daemon (`mongod.exe`) hidden in the background, executes the entire `spark_mongo.py` integration payload to write the DataFrames directly into the database, prints out the successful results, and finally neatly kills the MongoDB background servers to save your battery power.*

### 3. Run Interactively (Jupyter Notebook)
If you prefer a browser-based notebook as highlighted in the PDF:
1. Open your Anaconda Prompt or Command Prompt.
2. Run `jupyter notebook`.
3. Before executing any cells, ensure you have manually started `mongod.exe`!
4. Open `Experiment_6_Spark_MongoDB.ipynb` to view the code cells containing explanations outlining the PySpark Data Integration Pipeline workflow.

## ✨ Technical Workflow Checked
1. **URI Configured:** The `.config("spark.mongodb.output.uri", "mongodb://127.0.0.1:27017/sparkdb.employee")` connection string automatically maps the write streams natively into port `27017`.
2. **DataFrame Writing:** `df.write.format("mongo").mode("append").save()` bridges the native PySpark DAG onto the DB document cluster.
3. **Data Verification:** `spark.read.format("mongo").load()` retrieves the injected collections back over the localhost pipeline to assert functional transmission.
