#!/bin/bash

# Make sure we're in the Terraform directory
TF_DIR="./aws-terraform-docker-project"

echo "🧹 Starting Infra cleanup..."

if [ ! -d "$TF_DIR" ]; then
  echo "❌ Directory '$TF_DIR' not found!"
  exit 1
fi

cd "$TF_DIR"

# Destroy infrastructure
echo "🗑️ Running 'terraform destroy'..."
terraform destroy -auto-approve

# Remove Terraform files
echo "🗂️ Removing Terraform state and cache files..."
rm -rf .terraform terraform.tfstate terraform.tfstate.backup

echo "✅ Cleanup complete."

echo ""
echo "🔍 Remember to log in to the AWS Console and double-check:"
echo "- EC2 instances"
echo "- VPCs"
echo "- EBS volumes / Snapshots"
echo "- Elastic IPs"
echo "- S3 buckets (if used)"
