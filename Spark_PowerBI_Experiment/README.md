# End-to-End Big Data Pipeline (Spark to Power BI)

This directory contains the codebase for **Experiment 12: Design and Implementation of an End-to-End Big Data Pipeline Using Apache Spark and Visualization Tools**.

## 📦 How to Clone this Specific Experiment
To prevent different experiments from overlapping, this code is versioned via a Git Tag. You can download *only* this exact PySpark Power BI streaming codebase by running:
```bash
git clone --branch v12.0-spark-powerbi https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
This capstone experiment demonstrates a fully functional batch-processing Big Data infrastructure. It algorithmically constructs a massive mock CSV dataset mimicking thousands of real-world `nyc_taxi` transactions, executes a resilient, multi-stage **Apache Spark** data pipeline to clean and aggregate average daily metrics, and natively formats the dataset (`C:/temp/daily_avg_fare.csv`) specifically for **Microsoft Power BI** extraction logic.

## 🚀 How to Execute the Analytics

1. Open Anaconda Prompt (or standard Windows Command Prompt).
2. Execute the single-click master orchestrator:
   ```cmd
   run_experiment.cmd
   ```

### What Happens Automatically:
1. **Dataset Generation:** `generate_dataset.py` initiates natively and crafts a massive 5000-row `nyc_taxi.csv` sandbox filled with random (and mathematically flawed) trip distances and JSON values representing realistic taxi anomalies.
2. **Jupyter Provisioning:** The pipeline compiles the raw PySpark codebase into an interactive `Experiment_12_BigData_Pipeline.ipynb` block.
3. **Data Transformation & Sanitization:** The core logic boots the Spark Session locally, parses the random schema strings, systematically purges all invalid Null rows and Negative numerical distances natively using `.filter()`, and engineers a consolidated Daily Average Fare.
4. **Data Aggregation:** Calculates aggregated averages natively matching exactly how your PDF documentation specified (`pickup_date` x `avg_fare`) converting the complex objects into static Pandas elements.

### 📊 Step 2: Visualizing in Power BI

Once the script completes perfectly, follow these manual dashboarding steps to visualize your data mapping:
1. Open **Power BI Desktop**.
2. Click **Get Data -> Text/CSV**, and natively path directly to:
   ```
   C:/temp/daily_avg_fare.csv
   ```
3. Load the data. Navigate to the Reports canvas.
4. Expand the Right Panel (`Data`) and drag `pickup_date` to the X-Axis, and `avg_fare` to the Y-Axis to instantiate the exact Line Charts indicated in the PDF assignment.
