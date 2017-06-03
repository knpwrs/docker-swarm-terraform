#!/usr/bin/env bash

# Exit if any of the intermediate steps fail
set -e

# Extract input variables
eval "$(jq -r '@sh "PRIVATE_KEY_PATH=\(.private_key_path) HOST=\(.host)"')"

# Get worker join token
WORKER=$(ssh -i $PRIVATE_KEY_PATH -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$HOST docker swarm join-token worker -q)
MANAGER=$(ssh -i $PRIVATE_KEY_PATH -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$HOST docker swarm join-token manager -q)

# Pass back a JSON object
jq -n --arg worker "$WORKER" --arg manager "$MANAGER" '{"worker":$worker,"manager":$manager}'
