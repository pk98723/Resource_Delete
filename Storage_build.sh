# Variables
RESOURCE_GROUP="myrg"
STORAGE_ACCOUNT_NAME="mystr98723"
LOCATION="centralindia"

# Create storage account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard_LRS --kind StorageV2

# Create a container
az storage container create --name lab2container --account-name $STORAGE_ACCOUNT_NAME --auth-mode login

# Upload a file
az storage blob upload --account-name $STORAGE_ACCOUNT_NAME --container-name lab2container --name sample.txt --file ./sample.txt --auth-mode login

az role assignment create --assignee $(az ad signed-in-user show --query id -o tsv) --role "Storage Blob Data Contributor" --scope "/subscriptions/e8b9650d-f8de-46cd-bec4-f688fae3b1c3/resourceGroups/myrg/providers/Microsoft.Storage/storageAccounts/mystr98723"

