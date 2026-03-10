import subprocess
import time
import os

print("=========================================================")
print("  Experiment 11: Real-Time Spark Streaming Pipeline")
print("=========================================================")

KAFKA_DIR = r"F:\kafka"
CREATE_NEW_CONSOLE = 0x00000010

def spawn_detached(cmd_args):
    return subprocess.Popen(
        cmd_args,
        creationflags=CREATE_NEW_CONSOLE,
        shell=True
    )

print("\n[1/5] Verifying Apache Kafka Infrastructure...")
if not os.path.exists(KAFKA_DIR):
    print("[ERROR] Kafka binaries are missing from F:\\kafka. Please complete Experiment 10 first.")
    exit(1)

# Generate the Jupyter Notebook natively
print("\n[2/5] Generating PySpark Streaming Notebook...")
subprocess.run(["python", "generate_jupyter.py"])

print("\n[3/5] Booting Zookeeper Service...")
zoo_cmd = f"cmd.exe /c {KAFKA_DIR}\\bin\\windows\\zookeeper-server-start.bat {KAFKA_DIR}\\config\\zookeeper.properties"
zoo_proc = spawn_detached(zoo_cmd)
time.sleep(10)

print("\n[4/5] Booting Kafka Broker Service...")
kafka_cmd = f"cmd.exe /c {KAFKA_DIR}\\bin\\windows\\kafka-server-start.bat {KAFKA_DIR}\\config\\server.properties"
broker_proc = spawn_detached(kafka_cmd)
time.sleep(30)

print("\n[5/5] Establishing 'sensor-data' Topic...")
topic_cmd = f"{KAFKA_DIR}\\bin\\windows\\kafka-topics.bat --create --bootstrap-server localhost:9092 --topic sensor-data --partitions 1 --replication-factor 1 --if-not-exists"
subprocess.run(topic_cmd, shell=True)
time.sleep(3)

print("\n[6/6] Launching Producer & Jupyter Server...")
print("- Starting Autonomous IoT Producer...")
prod_cmd = "cmd.exe /k python tableau_sensor_producer.py"
prod_proc = spawn_detached(prod_cmd)
time.sleep(3)

print("- Starting Jupyter Notebook Server...")
print("\n[ACTION REQUIRED]:")
print(" 1. Jupyter will open in your web browser.")
print(" 2. Open 'Experiment_11_SparkStreaming.ipynb'.")
print(" 3. Run all cells to begin streaming.")
print(" 4. Close this terminal window ONLY when you are completely finished with the experiment.")
print("    (Closing this terminal auto-terminates Kafka, Zookeeper, and the Producer.)\n")

try:
    subprocess.run(["jupyter", "notebook", "Experiment_11_SparkStreaming.ipynb"])
except KeyboardInterrupt:
    print("\n[INFO] Caught interrupt. Closing...")

print("\n[INFO] Tearing down background service nodes gracefully...")
subprocess.run("taskkill /f /im java.exe >nul 2>&1", shell=True)
subprocess.run("taskkill /f /im python.exe >nul 2>&1", shell=True)

print("\n[SUCCESS] Pipeline Execution Terminated.")
