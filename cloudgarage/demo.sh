### Config
## Vcenter
# UI
https://vcsa.cpod-sirius.az-fkd.cloud-garage.net/
# Applicance :
https://vcsa.cpod-sirius.az-fkd.cloud-garage.net:5480
# Login | Pasword
administrator@cpod-sirius.az-fkd.cloud-garage.net
kCtQV0sYkNu!

## cpod-router : 172.17.8.1

## Service Installer : 
http://172.17.8.227:8888/#/ui
# Login | Password
root
ecocenter
# Configuration:
/opt/vmware/arcas/src/vsphere-dvs-tkgs-wcp.json
# Command to launch install from service installer
arcas --env vsphere --file /opt/vmware/arcas/src/vsphere-dvs-tkgs-wcp.json --avi_configuration --avi_wcp_configuration --enable_wcp --verbose


### OPEN Chrome
https://vcsa.cpod-sirius.az-fkd.cloud-garage.net/

http://172.17.8.227:8888/#/ui

https://tanzuemea.tmc.cloud.vmware.com/clustergroups/fklein-cg/overview




### Start Demo ### 
# 1. Create a dev cluster in Hors Prod Namespace with TMC
# - Name: tkgs-dev02
# - Version Kubernetes: v1.21.6+vmware.1-tkg.1.b3d708a

# 2. Scale the cluster with TMC - Add a node

# 3. Provision a Persistent volumes.
# Connect to the k8s cluster
export CONTROL_PLANE_IP_H2OWCP='10.18.3.3'
export VC_USERNAME='administrator@cpod-sirius.az-fkd.cloud-garage.net'
export TKG_NAMESPACE='horsprod'
export TANZU_TOOLS_FILES_PATH='/Users/kfrederic/Documents/GitHub/TKG/cloudgarage'
export TKG_CLUSTER='tkgs-dev01'

kubectl vsphere login --server $CONTROL_PLANE_IP_H2OWCP --vsphere-username $VC_USERNAME --insecure-skip-tls-verify  --tanzu-kubernetes-cluster-name tkgs-dev01 --tanzu-kubernetes-cluster-namespace horsprod

# type the password
kCtQV0sYkNu!

# Je déploie une app d'abord.
kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated
kubectl create deployment fred --image yfke8313/blog:2022-08-23-16-29-07
kubectl expose deployment fred --port 80 --type LoadBalancer

kubectl expose --namespace default svc/prometheus-kube-prometheus-prometheus --port 9090:9090 --type LoadBalancer

# Je crée un PVC
cd /Users/kfrederic/Documents/GitHub/TKG/cloudgarage

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: silver-storage-policy
  resources:
    requests:
        storage: 3Gi

# create pvc :
k apply -f pvc.yaml

# 4. Update the Kubernetes cluster version
# Go to TMC and click to upgrade the cluster in the last version.

# 5. Supervision :
show the TMC dashboard
# Prometheus
kubectl port-forward --namespace default svc/prometheus-kube-prometheus-prometheus 9090:9090

http://localhost:9090
# filter:
container_memory_working_set_bytes

## Grafana 
# Password: 
yYePa1QnNS
## Export UI
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 3000

http://localhost:3000/d/JABGX_-mz/cluster-monitoring-for-kubernetes?orgId=1&refresh=10s

# TO Infra
https://vmware.wavefront.com/u/rNsjycZJrF?t=map-sales-sandbox

# TO Apps
https://vmware.wavefront.com/u/WYWCgR1V9d?t=map-sales-sandbox


### OPEN Chrome
https://h2o.vmware.com/
https://h2o.vmware.com/my-resources/h2o-4-3004

# Service Installer
http://10.220.28.3:8888/#/ui

# Vcenter
https://vc01.h2o-4-3004.h2o.vmware.com/

# Harbor
https://10.220.6.165/

# TMC
https://tanzuemea.tmc.cloud.vmware.com/clustergroups/fklein-cg/overview

# AWS
https://console.cloudgate.vmware.com/ui/#/home?provider=aws

# TSM
https://prod-2.nsxservicemesh.vmware.com/global-namespaces-detail/fkl-azure/gns-topology
http://20.223.44.34/

# TO Infra
https://vmware.wavefront.com/u/rNsjycZJrF?t=map-sales-sandbox

# TO Apps
https://vmware.wavefront.com/u/WYWCgR1V9d?t=map-sales-sandbox





------------------- END --------------------------------------
# Demo 
export CONTROL_PLANE_IP_H2OWCP='10.220.6.162'
export VC_USERNAME='administrator@vsphere.local'
export TKG_NAMESPACE='horsprod'
export TANZU_TOOLS_FILES_PATH='/Users/kfrederic/Documents/GitHub/TKG/H2O'
export TKG_CLUSTER='tkgs-dev01'

#1 Deploy a workload Cluster 
kubectl vsphere login --server $CONTROL_PLANE_IP_H2OWCP --vsphere-username $VC_USERNAME --insecure-skip-tls-verify
kubectl config use-context prod-10.220.6.162
k apply -f /Users/kfrederic/Documents/GitHub/TKG/H2O/workload_prod_cluster01.yaml
k get tkc -w

#2 Scaling / Scale Out cluster DEV
## nouvel onglet command line
kubectl vsphere login --server $CONTROL_PLANE_IP_H2OWCP --vsphere-username $VC_USERNAME --insecure-skip-tls-verify
kubectl config use-context horsprod
k get tkc 

k edit tkc/tkgs-dev01
## passer le nombre de noeud à 1
k get vm -w


#3 Mise à jour d'un Cluster
k get tkc
## je constate une mise à jour disponible.
## Pour info, les masters et les workers ne peuvent pas avoir de version diffèrente. 
## je liste les versions de Kubernetes Tanzu disponible (Sur le Vcenter)

k get tanzukubernetesrelease 
## ou si je suis fénéant --> k get tkr

## je choisi le nom de la release => v1.22.9---vmware.1-tkg.1.cc71bc8
k edit tkc/tkgs-dev01
## maj + v pour surligner et supprimer les versions tkr / reference / name

#4
## j'ajoute mon cluster prod à TMC

kubectl vsphere login --server $CONTROL_PLANE_IP_H2OWCP --vsphere-username $VC_USERNAME --insecure-skip-tls-verify  --tanzu-kubernetes-cluster-name tkgs-prod01 --tanzu-kubernetes-cluster-namespace prod



#5 je déploie une app 
## je me connecte sur mon cluster
kubectl vsphere login --server $CONTROL_PLANE_IP_H2OWCP --vsphere-username $VC_USERNAME --insecure-skip-tls-verify  --tanzu-kubernetes-cluster-name tkgs-dev01 --tanzu-kubernetes-cluster-namespace horsprod


kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated
kubectl create deployment nginx --image nginx:latest
kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl create deployment fred --image yfke8313/blog:2022-08-23-16-29-07
kubectl expose deployment fred --port 80 --type LoadBalancer




# ----------------------------
# Login
kubectl vsphere login --server vc01cl01-wcp.h2o-4-1731.h2o.vmware.com --vsphere-username 	administrator@vsphere.local --insecure-skip-tls-verify

# change context
kubectl config use-context dev

# list VM class
kubectl get virtualmachineclassbindings

# List Version of Kubernetes 
kubectl get tkr

# deploy workload cluster on dev
k apply -f workload_dev_cluster01.yaml

# change context on prod
kubectl config use-context prod

# deploy workload cluster on prod
k apply -f workload_prod_cluster01.yaml

# Register Supervisor Cluster on TMC
https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-using/GUID-EB507AAF-5F4F-400F-9623-BA611233E0BD.html
https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-using/GUID-CC6E721E-43BF-4066-AA0A-F744280D6A03.html#GUID-CC6E721E-43BF-4066-AA0A-F744280D6A03

kubectl create -f tmc-registration.yaml
kubectl -n svc-tmc-c8 describe agentinstall tmc-agent-installer-config

# Activate Data Protection on TMC

# Connect to K8s

kubectl vsphere login --server vc01cl01-wcp.h2o-4-1731.h2o.vmware.com \
--vsphere-username administrator@vsphere.local  \
--insecure-skip-tls-verify \
--tanzu-kubernetes-cluster-name tkgs-dev01 \
--tanzu-kubernetes-cluster-namespace dev

# Deploy apps

k run sarycom --image=yfke8313/sarycom:2022-11-03-00-13-43