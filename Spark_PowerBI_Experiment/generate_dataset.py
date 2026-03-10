import csv
import random
from datetime import datetime, timedelta
import os

print("=========================================================")
print(" [GENERATOR] NYC Taxi Trip Dataset Simulator")
print("=========================================================")

OUTPUT_FILE = "nyc_taxi.csv"
NUM_RECORDS = 5000

# Base parameters for realistic taxi generation
START_DATE = datetime(2026, 3, 1)
PAYMENT_TYPES = ["Credit Card", "Cash", "No Charge", "Dispute"]

print(f"[INFO] Generating {NUM_RECORDS} mock trips into {OUTPUT_FILE}...")

def generate_random_timestamp(start_date, max_days_offset=7):
    random_seconds = random.randint(0, max_days_offset * 24 * 60 * 60)
    return start_date + timedelta(seconds=random_seconds)

with open(OUTPUT_FILE, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Define EXACT schema required by the assignment PDF
    writer.writerow([
        "tpep_pickup_datetime", 
        "tpep_dropoff_datetime", 
        "passenger_count", 
        "trip_distance", 
        "fare_amount", 
        "payment_type"
    ])
    
    for _ in range(NUM_RECORDS):
        pickup_time = generate_random_timestamp(START_DATE)
        
        # Add random trip duration (3 mins to 60 mins)
        duration_seconds = random.randint(180, 3600)
        dropoff_time = pickup_time + timedelta(seconds=duration_seconds)
        
        # Sometimes generate invalid data to test "Data Cleaning" steps in PySpark!
        # 5% chance of invalid distance (negative or zero)
        if random.random() < 0.05:
            trip_distance = round(random.uniform(-5.0, 0.0), 2)
        else:
            trip_distance = round(random.uniform(0.5, 25.0), 2)
            
        # 5% chance of invalid fare
        if random.random() < 0.05:
            fare_amount = round(random.uniform(-10.0, 0.0), 2)
        else:
            # Base fare roughly tied to distance
            fare_amount = round(3.00 + (trip_distance * 2.50) + random.uniform(0, 10.0), 2)
            
        passenger_count = random.randint(1, 6)
        payment = random.choice(PAYMENT_TYPES)
        
        writer.writerow([
            pickup_time.strftime("%Y-%m-%d %H:%M:%S"),
            dropoff_time.strftime("%Y-%m-%d %H:%M:%S"),
            passenger_count,
            trip_distance,
            fare_amount,
            payment
        ])

print(f"[SUCCESS] Dataset {OUTPUT_FILE} created successfully. ({os.path.getsize(OUTPUT_FILE) / 1024:.2f} KB)")
