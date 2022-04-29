# Connect to AKSCluster1
az aks get-credentials --name AKSCluster1 -g AKSResourceGroup
# Create pods in AKSCluster1 
kubectl run pod1 --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine --labels "app=backend" --expose --port 80
kubectl run pod2 --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine 
# Create services in AKSCluster1
kubectl run webapp --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
kubectl expose pod webapp --port=8765 --target-port=9376 --name=example-service --type=LoadBalancer
# Get pod ips 
kubectl get pods -o wide --all-namespaces
# Get service ips
kubectl get svc -o wide --all-namespaces

####################################################################################################
# Connect to AKSCluster2
az aks get-credentials --name AKSCluster2 -g AKSResourceGroup
# Create pods in AKSCluster2
kubectl run pod3 --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine --labels "app=frontend" --expose --port 80
kubectl run pod4 --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine 
# Create services in AKSCluster2
kubectl run webapp --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
kubectl expose pod webapp --port=8765 --target-port=9376 --name=example-service --type=LoadBalancer
# Get pod ips 
kubectl get pods -o wide --all-namespaces
# Get service ips
kubectl get svc -o wide --all-namespaces

####################################################################################################
## Test connectivity from AKSCluster1 
az aks get-credentials --name AKSCluster1 -g AKSResourceGroup
# Run terminal inside a testpod
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod 
# Try connecting to any pod-ip in cluster 2 
# Verified: pod IP is reachable
curl <pod-ip>
# Try connecting to any service-ip in cluster 2
# Verified: Service IP is unreachable
curl <service-ip>

####################################################################################################
## Test connectivity from AKSCluster2
az aks get-credentials --name AKSCluster2 -g AKSResourceGroup
# Run terminal inside a testpod
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod 
# Try connecting to any pod-ip in cluster 1
# Verified: pod IP is reachable
curl <pod-ip>
# Try connecting to any service-ip in cluster 1
# Verified: Service IP is unreachable
curl <service-ip>