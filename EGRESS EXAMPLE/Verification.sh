# Connect to AKS cluster 2
az aks get-credentials --resource-group AKSResourceGroup --name AKSCluster2
# Create a deployment to bring up 3 pods with app:frontend in Cluster 2
kubectl apply -f "C:\github\Spike-on-peering-and-network-policy\EGRESS EXAMPLE\Deployment.yaml"
# Create some pods in Cluster 2 without app:frontend (to verify network policy)
kubectl run pod1 --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine --labels "app=Anyapp" --expose --port 80
# Deploy the internal load balancer
kubectl apply -f "C:\github\Spike-on-peering-and-network-policy\EGRESS EXAMPLE\internallb.yaml"
# Get pod-ips
kubectl get pods -o wide --all-namespaces 
# Get frontend-ip of internal load balancer
kubectl get service internal-app
# To get more details about the load balancer 
kubectl describe svc internal-app


## Connect to AKS cluster 1
az aks get-credentials --resource-group AKSResourceGroup --name AKSCluster1
# For verification -
# Before applying the network policy file: Egress to any pod in Cluster 2 is allowed
# Try making an egress connection from pods with app:backend in cluster 1 to any pod with/without app:frontend in Cluster 2
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --labels "app=backend"
curl [pod-ip]
# Specify the external-ip of internal load balancer of cluster 2 in ipblock of egress section of cluster 1
# Now, apply the network policy file 
kubectl apply -f "C:\github\Spike-on-peering-and-network-policy\EGRESS EXAMPLE\Network policy.yaml"
# Try making an egress connection to any pod with/without app:frontend in Cluster 2
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --labels "app=backend"
curl [pod-ip]
