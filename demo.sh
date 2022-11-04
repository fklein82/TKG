### OPEN Chrome
https://h2o.vmware.com/
https://h2o.vmware.com/my-resources/h2o-4-1731

# Service Installer
http://10.220.28.3:8888/#/ui

# Vcenter
https://vc01.h2o-4-1731.h2o.vmware.com/

# TMC
https://tanzuemea.tmc.cloud.vmware.com/clustergroups/fklein-cg/overview

# AWS
https://console.cloudgate.vmware.com/ui/#/home?provider=aws

# TSM
https://prod-2.nsxservicemesh.vmware.com/home?view=global-namespaces

http://51.104.147.110/

# TO Infra
https://vmware.wavefront.com/u/rNsjycZJrF?t=map-sales-sandbox

# TO Apps
https://vmware.wavefront.com/u/WYWCgR1V9d?t=map-sales-sandbox

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