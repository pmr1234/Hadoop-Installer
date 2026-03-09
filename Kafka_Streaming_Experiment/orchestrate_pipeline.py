import subprocess
import time
import os

print("===========================================")
print("  Experiment 10: Apache Kafka Streaming")
print("===========================================")

KAFKA_DIR = r"F:\kafka"
CREATE_NEW_CONSOLE = 0x00000010

# Helper to spawn detached processes
def spawn_detached(cmd_args):
    return subprocess.Popen(
        cmd_args,
        creationflags=CREATE_NEW_CONSOLE,
        shell=True # Shell=True is required for executing .bat files securely on Windows
    )

print("\n[1/5] Setting up Apache Kafka Binaries...")
if not os.path.exists(KAFKA_DIR):
    print("[INFO] Kafka directory not found. Please run auto_install_kafka.cmd first.")
    exit(1)
print(f"[INFO] Kafka installation verified at {KAFKA_DIR}.")

print("\n[2/5] Booting Zookeeper Service...")
# We use cmd /c because without it, shell=True might trap stdin. CREATE_NEW_CONSOLE guarantees a fresh window.
zoo_cmd = f"cmd.exe /c {KAFKA_DIR}\\bin\\windows\\zookeeper-server-start.bat {KAFKA_DIR}\\config\\zookeeper.properties"
zoo_proc = spawn_detached(zoo_cmd)
time.sleep(10)

print("\n[3/5] Booting Kafka Broker Service...")
kafka_cmd = f"cmd.exe /c {KAFKA_DIR}\\bin\\windows\\kafka-server-start.bat {KAFKA_DIR}\\config\\server.properties"
broker_proc = spawn_detached(kafka_cmd)
time.sleep(15)

print("\n[4/5] Establishing 'sensor-data' Topic...")
topic_cmd = f"{KAFKA_DIR}\\bin\\windows\\kafka-topics.bat --create --bootstrap-server localhost:9092 --topic sensor-data --partitions 1 --replication-factor 1 --if-not-exists"
subprocess.run(topic_cmd, shell=True)

print("\n[5/5] Launching Spark-Kafka Data Pipeline...")
print("- Starting Autonomous Producer...")
prod_cmd = "cmd.exe /k python sensor_producer.py"
prod_proc = spawn_detached(prod_cmd)
time.sleep(3)

print("- Starting Spark/Matplotlib Visualization (Consumer)...")
# Run consumer in foreground so Matplotlib blocks and renders natively to the user
try:
    subprocess.run(["python", "sensor_stream.py"])
except KeyboardInterrupt:
    print("\n[INFO] Caught interrupt. Closing...")

print("\n[INFO] Matplotlib interface closed. Tearing down background service nodes gracefully...")
# Natively terminate the Java background processes and Python producer
subprocess.run("taskkill /f /im java.exe >nul 2>&1", shell=True)
subprocess.run("taskkill /f /im python.exe >nul 2>&1", shell=True)

print("\n[SUCCESS] Kafka Streaming Pipeline Execution Completed.")
