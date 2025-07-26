#!/bin/bash

RESOURCE_GROUP="myrg"
LOCATION="centralindia"
VNET="myvnet"
SUBNET1="mysubnet1"
SUBNET2="mysubnet2"
Vnet_PREFIX="10.0.0.0/16"
PREFIX1="10.0.1.0/24"
PREFIX2="10.0.2.0/24"
NSG="mynsg"
PUBLICIP="mypublicip"
VMNAME="myvm"
VMNIC="mynic"

echo "Creating resource group..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

echo "Creating vnet..."
az network vnet create --resource-group "$RESOURCE_GROUP" --name "$VNET" --address-prefix "$Vnet_PREFIX"

echo "Creating first subnet..."
az network vnet subnet create --resource-group "$RESOURCE_GROUP" --vnet-name "$VNET" --name "$SUBNET1" --address-prefix "$PREFIX1"

echo "Creating second subnet..."
az network vnet subnet create --resource-group "$RESOURCE_GROUP" --vnet-name "$VNET" --name "$SUBNET2" --address-prefix "$PREFIX2"

echo "Creating network security group..."
az network nsg create --resource-group "$RESOURCE_GROUP" --name "$NSG"

echo "Creating nsg rule..."
az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG" --name Allow-rdp --priority 1001 --access Allow --protocol TCP --direction Inbound --source-address-prefixes "*" 
--source-port-ranges "*" --destination-port-ranges 3389 --destination-address-prefixes "*"

echo "Creating public ip..."
az network public-ip create --resource-group "$RESOURCE_GROUP" --name "$PUBLICIP"

echo "Creating nic and attaching to one subnet..."
az network nic create --resource-group "$RESOURCE_GROUP" --name mynic --vnet-name "$VNET" --subnet "$SUBNET1" --network-security-group "$NSG" --public-ip-address "$PUBLICIP"

echo "Creating VM and attaching nic..."
az vm create --resource-group "$RESOURCE_GROUP" --name "$VMNAME" --nics "$VMNIC" --image Win2019Datacenter --size Standard_B2ms --admin-username azureuser --admin-password 'P@ssw0rd@2025'

echo "List the public created to the VM to login..."
az vm list-ip-addresses -g "$RESOURCE_GROUP" -n "$VMNAME"
