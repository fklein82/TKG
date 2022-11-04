## Prepare AKS Cluster

# Azure login
az login --use-device-code

# Set your default subscription
az account list --output table
az account set --subscription baf304df-eb50-4acf-948e-0b877396ac4f
az account show --output table

# Preprare
# Add pod security policies support preview (required for learningcenter)
az extension add --name aks-preview
az feature register --name PodSecurityPolicyPreview --namespace Microsoft.ContainerService

# Wait until the status is "Registered"
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/PodSecurityPolicyPreview')].{Name:name,State:properties.state}"
az provider register --namespace Microsoft.ContainerService

# Deploy Cluster AKS
az group create --location northeurope --name 'aks-tsm-dev01'
### Next step will deploy the Cluster - Take 30 min to complete
az aks create --resource-group 'aks-tsm-dev01' --name 'aks-tsm-dev01' --node-count 3 --node-vm-size Standard_DS3_v2 --node-osdisk-size 500 --enable-pod-security-policy --generate-ssh-keys
az aks get-credentials --resource-group 'aks-tsm-dev01' --name 'aks-tsm-dev01'

# RBAC
kubectl create clusterrolebinding tap-psp-rolebinding --group=system:authenticated --clusterrole=psp:privileged

# Add Cluster to TMC
# Deploy TSM from TMC

# Deploy Fitness App on the #1 Cluster (AZURE)
cd /home/azureuser/acme_fitness_demo/kubernetes-manifests

kubectl apply -f secrets.yaml
kubectl apply -f /home/azureuser/acme_fitness_demo/istio-manifests/gateway.yaml
kubectl apply -f acme_fitness_cluster1.yaml

# Find the External IP (Gateway ISTIO)
k get all -A


# Deploy the #2 AKS Cluster

# Deploy Cluster AKS
az group create --location northeurope --name 'aks-tsm-dev02'
### Next step will deploy the Cluster - Take 30 min to complete
az aks create --resource-group 'aks-tsm-dev02' --name 'aks-tsm-dev02' --node-count 3 --node-vm-size Standard_DS3_v2 --node-osdisk-size 500 --enable-pod-security-policy --generate-ssh-keys
az aks get-credentials --resource-group 'aks-tsm-dev02' --name 'aks-tsm-dev02'

# RBAC
kubectl create clusterrolebinding tap-psp-rolebinding --group=system:authenticated --clusterrole=psp:privileged

# Add Cluster to TMC
# Deploy TSM from TMC

# Deploy Fitness App on the #2 Cluster (AZURE)
git clone https://github.com/vmwarecloudadvocacy/acme_fitness_demo -b dkalani-dev3

cd /home/azureuser/acme_fitness_demo/kubernetes-manifests

kubectl apply -f secrets.yaml
kubectl apply -f /home/azureuser/acme_fitness_demo/istio-manifests/gateway.yaml
kubectl apply -f acme_fitness_cluster2.yaml

# Find the External IP (Gateway ISTIO)
k get all -A

# GO to TSM
Create the global load Balancer on default namespace

Then check the UI Portal



---- OPTIONNAL ON AWS ---- NOT WORKING FOR THE MOMENT ----
# Deploy AKS Cluster
https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks

# copy past variables

git clone https://github.com/hashicorp/learn-terraform-provision-eks-cluster

cd learn-terraform-provision-eks-cluster

terraform init

terraform apply

aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)

# change context
k config use-context arn:aws:eks:us-east-2:974606045370:cluster/education-eks-w1Hsr61e

# Add Cluster to TMC
# Deploy TSM from TMC


