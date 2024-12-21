#!/bin/bash

# Docker image name
IMAGE="${DOCKER_IMAGE:-pharisaeuss/suiteserver}"

# Container names
SRV1="srv1"
SRV2="srv2"
SRV3="srv3"

# CPU cores
declare -A CORES=(
    ["$SRV1"]="0"
    ["$SRV2"]="1"
    ["$SRV3"]="2"
)

# Thresholds and intervals
BUSY=50
IDLE=10
SLEEP_INTERVAL=10
COUNT=2
INTERVAL_FOR_UPDATE=240

# Function to check CPU usage
cpu_container() {
    local container_name=$1
    docker stats --no-stream --format "{{.CPUPerc}}" "$container_name" | tr -d '%' || echo "0"
}

# Function to update containers
container_container() {
    docker pull "$IMAGE"

    for container in "${!CORES[@]}"; do
        if docker ps | grep -q "$container"; then
            TEMP_CONTAINER="${container}_temp"
            docker run -d --name "$TEMP_CONTAINER" --cpuset-cpus="${CORES[$container]}" "$IMAGE"

            docker stop "$container"
            docker rm "$container"
            docker rename "$TEMP_CONTAINER" "$container"
        fi
    done
}

# Start container
start_container() {
    local container=$1
    local core=$2
    echo "Starting $container on core $core..."
    docker run -d --name "$container" --cpuset-cpus="$core" "$IMAGE"
}

# Stop container
stop_container() {
    local container=$1
    echo "Stopping $container..."
    docker stop "$container"
    docker rm "$container"
}

# Initialize first container
echo "Initializing $SRV1..."
start_container "$SRV1" "${CORES[$SRV1]}"

# Counters
declare -A busy_counters idle_counters

last_update_time=$(date +%s)

while true; do
    current_time=$(date +%s)

    for container in "${!CORES[@]}"; do
        if docker ps | grep -q "$container"; then
            cpu_usage=$(cpu_container "$container")

            if (( $(echo "$cpu_usage > $BUSY" | bc -l) )); then
                ((busy_counters[$container]++))
                idle_counters[$container]=0

                if [[ $container == "$SRV1" && ${busy_counters[$container]} -ge $CONSECUTIVE_COUNT && -z "$(docker ps -q -f name=$SRV2)" ]]; then
                    echo "Starting $SRV2 on core ${CORES[$SRV2]}..."
                    start_container "$SRV2" "${CORES[$SRV2]}"
                elif [[ $container == "$SRV2" && ${busy_counters[$container]} -ge $CONSECUTIVE_COUNT && -z "$(docker ps -q -f name=$SRV3)" ]]; then
                    echo "Starting $SRV3 on core ${CORES[$SRV3]}..."
                    start_container "$SRV3" "${CORES[$SRV3]}"
                fi
            elif (( $(echo "$cpu_usage < $IDLE" | bc -l) )); then
                busy_counters[$container]=0
                ((idle_counters[$container]++))

                if [[ ${idle_counters[$container]} -ge $CONSECUTIVE_COUNT && $container != "$SRV1" ]]; then
                    stop_container "$container"
                fi
            else
                busy_counters[$container]=0
                idle_counters[$container]=0
            fi
        fi
    done

    # Update containers every 4 minutes
    if (( current_time - last_update_time >= INTERVAL_FOR_UPDATE )); then
        container_update
        last_update_time=$(date +%s)
    fi

    sleep "$SLEEP_INTERVAL"
done
