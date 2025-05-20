#!/bin/bash

process_order() {
    local OrderID=$1 FromCity=$2 ToCity=$3 ItemType=$4
    local closest_agent="" closest_city="" min_distance=9999.99

    # Read agents file and calculate distance
    while IFS=',' read -r AgentID _ City _ _ _; do
        # Get distance using Python script
        distance=$(python3 DistancesBitweenCities.py "$FromCity" "$City" | grep -Eo '[0-9]+\.[0-9]+' || echo "not found")
        
        if [[ "$distance" != "not found" && $(echo "$distance < $min_distance" | bc -l) -eq 1 ]]; then
            min_distance=$distance
            closest_agent=$AgentID
            closest_city=$City
        fi
    done < <(tail -n +2 "$AGENTS_FILE")

    if [ -n "$closest_agent" ]; then
        echo "$OrderID,$FromCity,$ToCity,$ItemType,$closest_agent,$closest_city,$min_distance"
    else
        echo "$OrderID,$FromCity,$ToCity,$ItemType,NO_AGENT_FOUND,,0.00"
    fi
}

# Process all orders
tail -n +2 "$ORDERS_FILE" | while IFS=',' read -r OrderID FromCity ToCity ItemType _ _ _ _; do
    echo "Processing $OrderID: $FromCity → $ToCity"
    process_order "$OrderID" "$FromCity" "$ToCity" "$ItemType" >> "$OUTPUT_FILE"
done

deactivate
echo "Processing complete. Results saved to $OUTPUT_FILE"
