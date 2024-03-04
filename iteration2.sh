#!/bin/bash

# Remove output.txt if it exists
[ -e output.txt ] && rm output.txt

QUERYDATE="2024/Mar/04"
BASECOMMANDS="base commands"
TAILCOMMANDS=" | tail -n 2"
SSH_TARGET="user@hostname"

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

    echo "echo \"$payload $product\"" >> commands.txt
    echo "$BASECOMMANDS//${PRODUCTS[$product]}/${PAYLOADS[$payload]}/$QUERYDATE/$TAILCOMMANDS" >> commands.txt
}

# Function to handle the inner loop
handle_inner_loop() {
    local product="$1"
    for payload in "${!PAYLOADS[@]}"; do
        print_output "$product" "$payload"
    done
}

# Handle the outer loop
for product in "${!PRODUCTS[@]}"; do
    handle_inner_loop "$product"
done > commands.txt

# Run the commands against the SSH target and save the responses
while IFS= read -r command; do
    ssh -n "$SSH_TARGET" "$command" >> output.txt
done < commands.txt

