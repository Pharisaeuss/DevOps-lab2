#!/bin/bash

# Infinite loop to make HTTP requests
while true; do
    # Generate a random number between 3 and 5
    sleep_time=$((RANDOM % 3 + 3))

    echo "Wait $sleep_time seconds for the next request"

    # Sleep for the generated random time
    sleep $sleep_time

    # Perform an HTTP GET request and print status
    curl -i -X GET "127.0.0.1/compute" & echo "HTTP GET request was send"
done
