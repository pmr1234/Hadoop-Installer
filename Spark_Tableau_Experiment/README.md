# Real-Time PySpark Streaming for Tableau Dashboard

This directory contains the codebase for **Experiment 11: Developing a dashboard using Tableau for insights from processed Big Data**.

## 📦 How to Clone this Specific Experiment
To prevent different experiments from overlapping, this code is versioned via a Git Tag. You can download *only* this exact PySpark + Kafka streaming codebase by running:
```bash
git clone --branch v11.0-spark-tableau https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
This project demonstrates the complete end-to-end Big Data Architecture required to power real-time Tableau Visualizations. It utilizes a background **Apache Kafka** cluster to ingest live, simulated IoT (Temperature & Humidity) JSON payloads. An active **PySpark Structured Streaming** Jupyter Notebook consumes these streams dynamically, transforming the structured telemetry into continuous `.csv` exports inside `output/sensor_data` optimized exactly for Tableau ingestion.

## 🚀 How to Execute the Analytics

1. Open Anaconda Prompt (or standard Windows Command Prompt).
2. Execute the single-click master orchestrator:
   ```cmd
   run_pipeline.cmd
   ```

### What Happens Automatically:
- **[Validation]** The script ensures that you have successfully installed Kafka inside `F:\kafka` (from Experiment 10) before securely orchestrating the dependencies.
- **[Orchestration]** A decoupled Python daemon `orchestrate_spark_stream.py` natively utilizes pure Windows API subsystem arrays to launch Zookeeper and Kafka background daemons on Windows flawlessly securely avoiding Anaconda's typical IO/subshell constraints.
- **[Producer]** The `tableau_sensor_producer.py` daemon launches invisibly and begins producing thermal readings from random sensors natively pushing into the `sensor-data` topic.
- **[Notebook Generation]** A headless Python logic script natively spins up the `Experiment_11_SparkStreaming.ipynb` Notebook on standard Jupyter dependencies.
- **[Browser UX]** Jupyter interacts with your browser natively. Open the notebook and run all cells. The system natively grabs the PySpark dependencies across Maven `spark-sql-kafka-0-10_2.12` and instantly starts tracking strings.
- **[Visualization]** You can now point your Tableau connection array straight onto the `output/sensor_data/*.csv` artifacts dynamically!

To gracefully stop the Kafka architecture seamlessly, close the Jupyter UI and then close the original `run_pipeline.cmd` console to release the Zookeeper background states efficiently.
