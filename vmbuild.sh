#!/bin/bash
echo "Creating resource group..."
az group create 
--name myrg 
--location centralindia

echo "Creating vnet..."
az network vnet create 
--resource-group myrg 
--name myvnet 
--address-prefix 10.0.0.0/16

echo "Creating first subnet..."
az network vnet subnet create 
--resource-group myrg 
--vnet-name myvnet 
--name mysubnet 
--address-prefix 10.0.1.0/24

echo "Creating second subnet..."
az network vnet subnet create 
--resource-group myrg 
--vnet-name myvnet 
--name mysubnet1 
--address-prefix 10.0.2.0/24

echo "Creating network security group..."
az network nsg create 
--resource-group myrg 
--name mynsg

echo "Creating nsg rule..."
az network nsg rule create 
--resource-group myrg 
--nsg-name mynsg 
--name Allow-rdp 
--priority 1001 
--access Allow  
--protocol TCP 
--direction Inbound 
--source-address-prefixes "*" 
--source-port-ranges "*" 
--destination-port-ranges 3389 
--destination-address-prefixes "*"

echo "Creating public ip..."
az network public-ip create 
--resource-group myrg 
--name mypubip

echo "Creating nic and attaching to one subnet..."
az network nic create 
--resource-group myrg 
--name mynic 
--vnet-name myvnet 
--subnet mysubnet 
--network-security-group mynsg 
--public-ip-address mypubip

echo "Creating VM and attaching nic..."
az vm create 
--resource-group myrg  
--name myvm  
--nics mynic 
--image Win2019Datacenter 
--size Standard_B2ms 
--admin-username azureuser 
--admin-password 'P@ssw0rd@2025'

echo "List the public created to the VM to login..."
az vm list-ip-addresses -g myrg -n myvm
