#!/bin/bash

# Activate virtual environment
source ~/venv_distance/bin/activate

# File paths
AGENTS_FILE="expanded_agents_data.csv"
ORDERS_FILE="expanded_orders_data.csv"
OUTPUT_FILE="assigned_orders.csv"

# Check files exist
if [ ! -f "$AGENTS_FILE" ] || [ ! -f "$ORDERS_FILE" ]; then
    echo "Error: Missing data files!"
    exit 1
fi

# Process orders
echo "OrderID,FromCity,ToCity,ItemType,BestAgent,BestCity,Distance(km)" > "$OUTPUT_FILE"
