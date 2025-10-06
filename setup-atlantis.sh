#!/bin/bash

# Complete Atlantis Setup Guide
echo "=== Atlantis Setup for Terraform/Terragrunt ==="

# Step 1: Build custom Atlantis image with Terragrunt
echo "Step 1: Building Atlantis image with Terragrunt..."
docker build -f Dockerfile.atlantis -t atlantis-terragrunt .

# Step 2: Create webhook secret (optional but recommended)
WEBHOOK_SECRET=$(openssl rand -hex 32)
echo "Generated webhook secret: $WEBHOOK_SECRET"
echo "Save this secret - you'll need it for GitHub webhook configuration"

# Step 3: Run Atlantis server
echo "Step 3: Starting Atlantis server..."
echo "Make sure to:"
echo "1. Replace SOME_PAT with your GitHub personal access token"
echo "2. Replace sangharsh-ranpise with your GitHub username"
echo "3. Update the repo allowlist if needed"

echo ""
echo "Docker command to run:"
echo "docker run -it --rm \\"
echo "  -p 4141:4141 \\"
echo "  -v $(pwd)/ssh_keys/atlantis_key:/atlantis_key \\"
echo "  -v $(pwd)/server.yaml:/etc/atlantis/server.yaml \\"
echo "  -e ATLANTIS_GH_TOKEN=\"SOME_TOKEN\" \\"
echo "  -e ATLANTIS_GH_USER=\"sangharsh-ranpise\" \\"
echo "  -e ATLANTIS_GH_WEBHOOK_SECRET=\"$WEBHOOK_SECRET\" \\"
echo "  -e ATLANTIS_REPO_ALLOWLIST=\"github.com/sangharsh-ranpise/customer-test-01-infra-live\" \\"
echo "  atlantis-terragrunt server \\"
echo "  --config /etc/atlantis/server.yaml"

echo ""
echo "=== GitHub Webhook Setup ==="
echo "1. Go to your GitHub repo: https://github.com/sangharsh-ranpise/customer-test-01-infra-live"
echo "2. Navigate to Settings > Webhooks"
echo "3. Click 'Add webhook'"
echo "4. Set Payload URL: http://YOUR_SERVER_IP:4141/events"
echo "5. Content type: application/json"
echo "6. Secret: $WEBHOOK_SECRET"
echo "7. Select events: Pull requests, Pushes, Issue comments, Pull request reviews"
echo "8. Make sure webhook is Active"

echo ""
echo "=== Testing ==="
echo "1. Create a new branch in your repo"
echo "2. Make changes to Terraform/Terragrunt files"
echo "3. Create a Pull Request"
echo "4. Comment 'atlantis plan' on the PR"
echo "5. After reviewing the plan, comment 'atlantis apply' (if approved)"