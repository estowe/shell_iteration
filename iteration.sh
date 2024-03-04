#!/bin/bash

BASECOMMANDS="base commands"
TAILCOMMANDS=" | tail -n 2"
SSH_TARGET="user@hostname"

# Remove output.txt if it exists
[ -e output.txt ] && rm output.txt

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

# Prompt the user for the date while defaulting to today
echo "Please enter the date (format: YYYY/MMM/DD). Press enter for today's date:"
read USERDATE
QUERYDATE=${USERDATE:-$(date +"%Y/%b/%d")}

# Prompt the user for a specific product and payload
while true; do
    echo "Please select a product:"
    select PRODUCT_CHOICE in "${!PRODUCTS[@]}" "All"; do
        if [ -n "$PRODUCT_CHOICE" ] || [ "$PRODUCT_CHOICE" = "All" ]; then
            break 2
        else
            echo "Invalid choice. Please try again." >&2
            break
        fi
    done
done

while true; do
    echo "Please select a payload:"
    select PAYLOAD_CHOICE in "${!PAYLOADS[@]}" "All"; do
        if [ -n "$PAYLOAD_CHOICE" ] || [ "$PAYLOAD_CHOICE" = "All" ]; then
            break 2
        else
            echo "Invalid choice. Please try again." >&2
            break
        fi
    done
done

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
        if [ -z "$PAYLOAD_CHOICE" ] || [ "$PAYLOAD_CHOICE" = "All" ] || [ "$PAYLOAD_CHOICE" = "$payload" ]; then
            print_output "$product" "$payload"
        fi
    done
}

# Handle the outer loop
for product in "${!PRODUCTS[@]}"; do
    if [ -z "$PRODUCT_CHOICE" ] || [ "$PRODUCT_CHOICE" = "All" ] || [ "$PRODUCT_CHOICE" = "$product" ]; then
        handle_inner_loop "$product"
    fi
done > commands.txt

# Run the commands against the SSH target and save the responses
while IFS= read -r command; do
    ssh -n "$SSH_TARGET" "$command" >> output.txt
done < commands.txt
