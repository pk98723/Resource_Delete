# Variables
RESOURCE_GROUP="myrg"
STORAGE_ACCOUNT_NAME="mystr"
LOCATION="centralindia"

# Create storage account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard_LRS --kind StorageV2

# Create a container
az storage container create --name lab2container --account-name $STORAGE_ACCOUNT_NAME --auth-mode login

# Upload a file
az storage blob upload --account-name $STORAGE_ACCOUNT_NAME --container-name lab2container --name sample.txt --file ./sample.txt --auth-mode login
