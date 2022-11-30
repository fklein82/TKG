### OPEN Chrome
https://h2o.vmware.com/
https://h2o.vmware.com/my-resources/h2o-4-3004

# Service Installer
http://10.220.28.3:8888/#/ui

# Vcenter
https://vc01.h2o-4-3004.h2o.vmware.com/

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


# Demo 
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

#4 je déploie une app 
## je me connecte sur mon cluster
kubectl vsphere login --server $CONTROL_PLANE_IP_H2OWCP --vsphere-username $VC_USERNAME --insecure-skip-tls-verify  --tanzu-kubernetes-cluster-name tkgs-dev01 --tanzu-kubernetes-cluster-namespace horsprod


kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated
kubectl create deployment nginx --image nginx:latest
kubectl expose deployment nginx --port 80 --type LoadBalancer





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