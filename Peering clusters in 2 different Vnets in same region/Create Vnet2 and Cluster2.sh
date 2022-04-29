# CREATE SECOND VNET AND CLUSTER PAIR AND CONFIGURE AZURE CNI-NETWORKING 

RESOURCE_GROUP_NAME="AKSResourceGroup"
CLUSTER_NAME="AKSCluster2"
LOCATION="westus"

# Create a virtual network and subnet
az network vnet create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name Vnet2 \
    --address-prefixes 10.2.0.0/16 \
    --subnet-name AKSSubnet2 \
    --subnet-prefix 10.2.3.0/24

# Get the subnet resource ID for the existing subnet into which the AKS cluster will be joined:
SUBNET_ID2=$(az network vnet subnet list \
     --resource-group $RESOURCE_GROUP_NAME \
    --vnet-name Vnet2 \
    --query "[0].id" --output tsv)

# Create AKS cluster inside the Vnet2
DNS_SERVICE_IP2="10.2.30.10"
SERVICE_CIDR2="10.2.30.0/24"
az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME \
    --no-ssh-key \
    --enable-managed-identity \
    --network-plugin azure \
    --network-policy azure \
    --vnet-subnet-id ${SUBNET_ID2} \
    --dns-service-ip ${DNS_SERVICE_IP2} \
    --service-cidr ${SERVICE_CIDR2} \
    --node-count 1
# Connect to the cluster 
az aks get-credentials -n "$CLUSTER_NAME" -g "$RESOURCE_GROUP_NAME"

