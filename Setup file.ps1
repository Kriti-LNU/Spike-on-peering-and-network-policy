RESOURCE_GROUP_NAME=myResourceGroup1
CLUSTER_NAME=myAKSCluster1
LOCATION=westus

# Create a resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create a virtual network and subnet
az network vnet create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name myVnet1 \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name myAKSSubnet1 \
    --subnet-prefix 10.240.0.0/16


# Get the subnet resource ID for the existing subnet into which the AKS cluster will be joined:
az network vnet subnet list \
     --resource-group $RESOURCE_GROUP_NAME \
    --vnet-name myVnet1 \
    --query "[0].id" --output tsv


az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name myAKSCluster1 \
    --network-plugin azure \
    --vnet-subnet-id <subnet-id>\
    --dns-service-ip 10.2.0.10 \
    --service-cidr 10.2.0.0/24 \
    --generate-ssh-keys


# ---------------------------------------------------------------------------------------------------------------------
## CREATE SECOND VNET AND CLUSTER PAIR AND CONFIGURE CNI-NETWORKING 

RESOURCE_GROUP_NAME=myResourceGroup2
CLUSTER_NAME=myAKSCluster2
LOCATION=westus

# Create a resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create a virtual network and subnet
az network vnet create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name myVnet2 \
    --address-prefixes 12.0.0.0/8 \
    --subnet-name myAKSSubnet2 \
    --subnet-prefix 12.240.0.0/16

# Get the subnet resource ID for the existing subnet into which the AKS cluster will be joined:
az network vnet subnet list \
     --resource-group $RESOURCE_GROUP_NAME \
    --vnet-name myVnet2 \
    --query "[0].id" --output tsv


az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name myAKSCluster2 \
    --network-plugin azure \
    --vnet-subnet-id <subnet-id>\
    --dns-service-ip 10.2.0.10 \
    --service-cidr 10.2.0.0/24 \
    --generate-ssh-keys