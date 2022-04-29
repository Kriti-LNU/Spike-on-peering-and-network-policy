# Let's start by creating cluster1 in Vnet1 
RESOURCE_GROUP_NAME="AKSResourceGroup"
CLUSTER_NAME="AKSCluster1"
LOCATION="westus"

# Create a resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create a virtual network and subnet
az network vnet create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name Vnet1 \
    --address-prefixes 10.0.0.0/16 \
    --subnet-name AKSSubnet1 \
    --subnet-prefix 10.0.1.0/24


# Get the subnet resource ID for the existing subnet into which the AKS cluster will be joined:
SUBNET_ID1=$(az network vnet subnet list \
     --resource-group $RESOURCE_GROUP_NAME \
    --vnet-name Vnet1 \
    --query "[0].id" --output tsv)


# Create AKS cluster inside the Vnet1
DNS_SERVICE_IP1="10.0.10.10"
SERVICE_CIDR1="10.0.10.0/24"
az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME \
    --no-ssh-key \
    --enable-managed-identity \
    --network-plugin azure \
    --network-policy azure \
    --vnet-subnet-id ${SUBNET_ID1} \
    --dns-service-ip ${DNS_SERVICE_IP1} \
    --service-cidr ${SERVICE_CIDR1} \
    --node-count 1

# Connect to the cluster 
az aks get-credentials -n "$CLUSTER_NAME" -g "$RESOURCE_GROUP_NAME"