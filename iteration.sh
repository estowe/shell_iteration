#!/bin/bash

QUERYDATE="2024/Mar/04"
BASECOMMANDS="base commands"
TAILCOMMANDS=" | tail -n 2"

# Define the PRODUCTS and PAYLOADS dictionaries
declare -A PRODUCTS=(
    ["product1"]="product_query1"
    ["product2"]="product_query2"
    ["product3"]="product_query3"
    ["product4"]="product_query4"
    ["product5"]="product_query5"
)

declare -A PAYLOADS=(
    ["payload1"]="PL1"
    ["payload2"]="PL2"
    ["payload3"]="PL3"
    ["payload4"]="PL4"
)

# Function to print the output
print_output() {
    local product="$1"
    local payload="$2"

    echo "echo $2 $1"
    echo "$BASECOMMANDS//${PRODUCTS[$product]}/${PAYLOADS[$payload]}/$QUERYDATE/$TAILCOMMANDS"
}

# Print the output for each combination
for product in "${!PRODUCTS[@]}"; do
    for payload in "${!PAYLOADS[@]}"; do
        print_output "$product" "$payload"
    done
done
