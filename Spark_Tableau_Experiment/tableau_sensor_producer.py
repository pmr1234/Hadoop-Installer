from kafka import KafkaProducer
import json
import time
import random
from datetime import datetime

print("=========================================================")
print(" [PRODUCER] Automated Kafka JSON Telemetry Generator ")
print("=========================================================")

try:
    producer = KafkaProducer(
        bootstrap_servers='localhost:9092',
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )
    print("[SUCCESS] Connected to Kafka Broker on localhost:9092")
except Exception as e:
    print(f"[ERROR] Failed to connect to Kafka Broker: {e}")
    exit(1)

print("[INFO] Pushing randomized JSON telemetry to 'sensor-data' topic...")
print("[INFO] Press Ctrl+C to safely stop the producer.\n")

try:
    while True:
        data = {
            "sensor_id": random.randint(1, 5),
            "temperature": round(random.uniform(20, 40), 2),
            "humidity": round(random.uniform(30, 80), 2),
            "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }
        producer.send("sensor-data", data)
        producer.flush()
        print(f" -> TX Broadcast: {data}")
        time.sleep(2)  # Delay matching the PDF requirement
except KeyboardInterrupt:
    print("\n[INFO] Shutting down producer safely.")
    producer.close()
