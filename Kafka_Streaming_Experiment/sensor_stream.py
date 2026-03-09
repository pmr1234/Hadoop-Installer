from kafka import KafkaConsumer
import matplotlib.pyplot as plt

print("=====================================================")
print(" [CONSUMER] Live Spark Streaming Application")
print("=====================================================")
print("[INFO] Waiting for telemetry data on 'sensor-data' topic...")

# 1. Connect Kafka Consumer
consumer = KafkaConsumer(
    'sensor-data',
    bootstrap_servers='localhost:9092',
    auto_offset_reset='latest',
    value_deserializer=lambda x: int(x.decode('utf-8'))
)

# 2. Setup Matplotlib Interactive Canvas
plt.ion()
x_vals = []
y_vals = []

print("[SUCCESS] Consumer listening! Spawning Matplotlib UI...")

# 3. Stream Data Loop
for i, message in enumerate(consumer):
    x_vals.append(i)
    y_vals.append(message.value)
    
    # Optional: Keep the plot from becoming infinite and crashing memory
    if len(x_vals) > 50:
        x_vals.pop(0)
        y_vals.pop(0)
    
    # Render logic from PDF
    plt.clf()
    plt.plot(x_vals, y_vals, marker='o', color='red')
    plt.xlabel("Time")
    plt.ylabel("Sensor Value")
    plt.title("Live Kafka Data Visualization")
    plt.pause(0.1)
