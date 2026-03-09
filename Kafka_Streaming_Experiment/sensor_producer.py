import time
import random
from kafka import KafkaProducer

print("=====================================================")
print(" [PRODUCER] Automated Kafka Telemetry Generator ")
print("=====================================================")

try:
    # Connect to the local Kafka Broker
    producer = KafkaProducer(
        bootstrap_servers=['localhost:9092'],
        value_serializer=lambda v: str(v).encode('utf-8')
    )
    print("[SUCCESS] Connected to Kafka Broker on localhost:9092")
except Exception as e:
    print(f"[ERROR] Failed to connect to Kafka Broker: {e}")
    exit(1)

print("[INFO] Pushing randomized integer temperatures to 'sensor-data' topic...")
print("[INFO] Press Ctrl+C to safely stop the producer.\n")

try:
    while True:
        # Simulate an IoT sensor value between 60.0 and 100.0 (using integers to match PDF instructions)
        sensor_val = random.randint(60, 100)
        print(f" -> TX Broadcast: {sensor_val} °F")
        
        # Send to topic exactly as consumer expects (raw integers decoded from utf-8 strings)
        producer.send('sensor-data', sensor_val)
        producer.flush()
        
        time.sleep(1) # Delay 1 second to make the visualization readable
except KeyboardInterrupt:
    print("\n[INFO] Shutting down producer safely.")
    producer.close()
