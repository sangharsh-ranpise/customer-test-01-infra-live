# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Terragrunt-based infrastructure repository managing Azure resources. The repository uses Atlantis for automated Terraform workflow execution via pull requests.

### Architecture

- **Atlantis Configuration**: `atlantis.yaml` and `server.yaml` define the Atlantis workflow
  - Uses `terragrunt` workflow with init, plan, and apply steps
  - Requires approval and mergeable status for applies
  - Project: `xdr-content` in `azure/dev/eastus/rg1/xdr-content`

- **Directory Structure**:
  - `azure/dev/eastus/rg1/xdr-content/`: Contains the main Terragrunt configuration
    - `terragrunt.hcl`: Terragrunt configuration pointing to local module
    - `module/main.tf`: Simple Terraform module with variable and output
  - `atlantis-test/`: Test directory with Terraform files
  - `ssh_keys/`: Directory for SSH key storage
  - `environment.yaml`: Environment configuration (currently set to `dev`)

### Atlantis Setup and Configuration

#### Prerequisites
1. **GitHub Personal Access Token** with repo permissions
2. **SSH key** for GitHub access (stored in `ssh_keys/atlantis_key`)
3. **Docker** installed on your server
4. **Public server** with port 4141 accessible for GitHub webhooks

#### Complete Setup Process

1. **Build Custom Atlantis Image**:
```bash
# Build Atlantis with Terragrunt support
docker build -f Dockerfile.atlantis -t atlantis-terragrunt .
```

2. **Run Setup Script**:
```bash
./setup-atlantis.sh
```

3. **Start Atlantis Server**:
```bash
docker run -it --rm \
  -p 4141:4141 \
  -v $(pwd)/ssh_keys/atlantis_key:/atlantis_key \
  -v $(pwd)/server.yaml:/etc/atlantis/server.yaml \
  -e ATLANTIS_GH_TOKEN="YOUR_GITHUB_TOKEN" \
  -e ATLANTIS_GH_USER="YOUR_GITHUB_USERNAME" \
  -e ATLANTIS_GH_WEBHOOK_SECRET="YOUR_WEBHOOK_SECRET" \
  -e ATLANTIS_REPO_ALLOWLIST="github.com/sangharsh-ranpise/customer-test-01-infra-live" \
  atlantis-terragrunt server \
  --config /etc/atlantis/server.yaml
```

4. **Configure GitHub Webhook**:
   - Go to repo Settings > Webhooks
   - Payload URL: `http://YOUR_SERVER_IP:4141/events`
   - Content type: `application/json`
   - Secret: Use the generated webhook secret
   - Events: Pull requests, Pushes, Issue comments, Pull request reviews

#### Atlantis Workflow
1. **Create PR** with Terraform/Terragrunt changes
2. **Comment `atlantis plan`** on PR to trigger planning
3. **Review the plan** output in PR comments
4. **Get PR approved** and ensure it's mergeable
5. **Comment `atlantis apply`** to apply changes
6. **Merge PR** after successful apply

#### Terragrunt Operations
```bash
# Local development
cd azure/dev/eastus/rg1/xdr-content
terragrunt init
terragrunt plan
terragrunt apply --auto-approve

# Batch operations
python updater.py
```

#### Configuration Files
- `atlantis.yaml`: Project-specific configuration
- `server.yaml`: Server-side workflow definitions
- `Dockerfile.atlantis`: Custom image with Terragrunt
- `setup-atlantis.sh`: Complete setup script

### Key Files
- `atlantis.yaml`: Atlantis project configuration
- `server.yaml`: Atlantis server and workflow definitions
- `updater.py`: Python script for batch Terragrunt operations
- `environment.yaml`: Environment configuration