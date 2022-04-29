#####################################
# Peer vnet 1 with vnet 2
#####################################
VNET1="Vnet1"
VNET2="Vnet2"
RESOURCE_GROUP_NAME="AKSResourceGroup"
# Get the id for Vnet1
VNET1_ID=$(az network vnet show --resource-group ${RESOURCE_GROUP_NAME} --name ${VNET1} --query id --out tsv)
# Get the id for Vnet2
VNET2_ID=$(az network vnet show --resource-group ${RESOURCE_GROUP_NAME} --name ${VNET2} --query id --out tsv)

# Peering Vnet1 to Vnet2

PEER12_NAME="${VNET1}-${VNET2}-peer"
az network vnet peering create \
  --name ${PEER12_NAME} \
  --resource-group ${RESOURCE_GROUP_NAME} \
  --vnet-name ${VNET1} \
  --remote-vnet ${VNET2} \
  --allow-vnet-access

# Peering Vnet2 to Vnet1
PEER12_NAME="${VNET2}-${VNET1}-peer"
az network vnet peering create \
  --name ${PEER12_NAME} \
  --resource-group ${RESOURCE_GROUP_NAME} \
  --vnet-name ${VNET2} \
  --remote-vnet ${VNET1} \
  --allow-vnet-access

