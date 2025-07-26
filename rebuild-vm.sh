#!/bin/bash
set -e

# Configurable variables
RESOURCE_GROUP="myrg"
VM_NAME="myvm"
LOCATION="eastus"
IMAGE="Win2019Datacenter"
SIZE="Standard_D2s_v3"
ADMIN_USER="azureuser"
ADMIN_PASS="P@ssw0rd@2025"
VNET_NAME="myVnet"
SUBNET_NAME="mySubnet"
IP_NAME="${VM_NAME}-ip"
NIC_NAME="${VM_NAME}-nic"
NSG_NAME="${VM_NAME}-nsg"
OSDISK_NAME="${VM_NAME}_osdisk"

echo "Deleting existing VM (if any)..."
az vm delete --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --yes || true

echo "Deleting NIC..."
az network nic delete --resource-group "$RESOURCE_GROUP" --name "$NIC_NAME" || true

echo "Deleting Public IP..."
az network public-ip delete --resource-group "$RESOURCE_GROUP" --name "$IP_NAME" || true

echo "Deleting OS Disk..."
az disk delete --resource-group "$RESOURCE_GROUP" --name "$OSDISK_NAME" --yes || true

echo "Creating Public IP..."
az network public-ip create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$IP_NAME" \
  --allocation-method Static

echo "Creating NIC..."
az network nic create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$NIC_NAME" \
  --vnet-name "$VNET_NAME" \
  --subnet "$SUBNET_NAME" \
  --network-security-group "$NSG_NAME" \
  --public-ip-address "$IP_NAME"

echo "Creating VM..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --nics "$NIC_NAME" \
  --image "$IMAGE" \
  --size "$SIZE" \
  --admin-username "$ADMIN_USER" \
  --admin-password "$ADMIN_PASS"

echo "✅ VM rebuilt successfully!"
