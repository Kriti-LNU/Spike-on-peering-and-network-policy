This is a demo for the verification of east-west connectivity in a multi-cluster peered setup.
For creating the setup we will follow the following steps:
1. Create Vnet1 and AKSCluster1
2. Create Vnet2 and AKSCluster2
3. Peer Vnet1 with Vnet2 
4. Peer Vnet2 with Vnet1

After creating the setup we will verify whether of not we can access pods and services on one cluster using pods in the other peered cluster.