# Real-Time Streaming with Kafka

This directory contains the codebase for **Experiment 10: Real-Time Streaming with Apache Kafka**. 

## 📦 How to Clone this Specific Experiment
To prevent different experiments from overlapping, this code is versioned via a Git Tag. You can download *only* this exact Kafka streaming codebase by running:
```bash
git clone --branch v10.0-kafka-streaming https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
This project demonstrates setting up an automated Apache Kafka Streaming pipeline. Telemetry integer values (simulating a live IoT sensor) are continuously broadcast over a centralized Kafka Broker Daemon onto the `sensor-data` topic. A disconnected Python daemon concurrently parses that broadcast and constructs an up-to-the-second Matplotlib line graph visually demonstrating the pipeline.

## 🚀 How to Execute the Analytics

1. Open Anaconda Prompt (or standard Windows Command Prompt).
2. Execute the single-click master orchestrator:
   ```cmd
   run_pipeline.cmd
   ```

### What Happens Automatically:
- **[Automation]** The script ensures `kafka_2.12-3.6.1.tgz` is fully extracted natively on `F:\kafka`.
- **[Orchestration]** A Python daemon spawns fully detached, clean Windows API terminals for both the Zookeeper Node and the Master Kafka Broker.
- **[Producer]** The `sensor_producer.py` daemon launches invisibly and generates random integer values (representing 60-100 Degree limits) and begins securely transmitting them to the `sensor-data` topic every 1000 milliseconds.
- **[Consumer]** The pipeline natively locks the main terminal into the `sensor_stream.py` `KafkaConsumer` listener loop, dynamically extracting the `utf-8` encoded payload arrays.
- **[Visualization]** A stunning line graph utilizing `plt.ion()` will spawn on your desktop and actively iterate over the incoming coordinates in real-time.

To gracefully shut down the massive Java background clusters when finished, simply press `Ctrl+C` inside the main terminal window, and the Python lifecycle controller will recursively garbage collect and kill the Zookeeper/Kafka threads automatically.
