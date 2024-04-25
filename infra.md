# Overview
The proposed infrastructure will be following the typical of private AKS:
- Vnet with the subnets for assigning the Ipv4 for the AKS's components
- The AKS with the private API server
- Control VM list for managing the deploying process such as Jumphost, Admin VM,...
![Private AKS Infrastructure](./images/Jenkins_Infra.svg)

This infra is followed the moderated AKS standard infrastructures. However,this is the simplificate version which minimized the resource to server the application on the AKS cluster. The main workflow:

Prepare the terraform resources -> Trigger to the repository -> CI build the cloud infrastructures -> Ansible to collect the inventory -> Config the enviroment -> Run script to configure Kubernetes admin from JumpHost -> Deploy the Jenkins server on AKS by Helm -> Manually config Jenkins Server.

# Azure Infrastructure
The Private AKS is deployed on the Azure cloud which is ensured the API Server is privately and only communicate with the Kubeneretes administrator from the Jumphost VM. Since the kubernetes's control plane on Azure is managed by Azure, the API server is the only gateway to communicated between the Worker node which is hosted the application container.However, the IP allocation is need to be customized to avoid the overlap with the resources. 
## Network
Customize the IP address in the Kubernets cluster is considered. For this reason the proposed network system will combine 2 Virtual network for the Database and the main application platforms:
- Vnet Workspace for the application platforms such as AKS, Jumphost VM, ...The subnet application: 
    + AKS resources: The address information for the pods, services,...
    + AKS node: Allocate the IP address for the worker node and the scale-set
    + Control VM: Include the VM of the Administrator team. That can be the Jumphost or the middle VM for control the other one.

- Vnet DB to control the storage actions, this storage resourece subnets: 
    + Keyvault: Credential informations
    + Container registry: Storage Applicaiton Images
    + Storage account: The rest of resource data such as: + Statefulsets data, infrastructure informations,...

The suggestion network system is not created the private endpoint for the AKS since the Vnet intergration feature is enabled. This feature will ultilize the delegated subnet for projecting the API server private endpoint directly
## Control VM
The VM from this module will be organized for the Adminstrator teams. For instance: Jumphost VM with the kubernetes admin credential to communicate the API server. The DatabaseVM to host and managed the database structures, or the Data science VM for DS team build the AI model which is integrate the application.
## AKS
The AKS will have the role to orchestration the application to automation the workload and the container services.
### Jenkins server
Jenkins server is the solution for automatically deploy the software for the Enduser. Beside automation task, this server is integrated with the AKS to guarantee the scaling ability. Moreover, this can be the configuration tools for the multiple resources on the cloud Provider. 

# Ansible solutions
The Jenkins will be deployed on the AKS with the statfull sets by Jenkins Helm Chart. This defination is located from ``` ./infra/k8s/jenkins```. In case you want to manually deploy, this directory is also included the guideline and the brief explaination. In other hand, you will modify the ``` ./k8s/jenkin/value-jenkin_helm.yaml```. The order deployment will be:

SSH to JumpHost -> Helm add Jenkins chart -> Create the storage class -> Deploy Jenkins Chart from values file by Helm

From this values file, we will follow the helm command to deploy it imperative ways: 
```
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
kubectl create -f sc_k8s.yaml
helm install jenkins -f values-jenkins_helm.yaml jenkinsci/jenkins
```
However, this project is proposed the declarative approaches by Ansible. From the machine run terraform, it will be created the inventory file for the JumphostVM. By this way, we will run 2 ansible: ``` ./infra/ansible/setup-aks_plays.yaml``` to copy the requirements manifest files and ``` ./infra/ansible/deploy-aks_plays.yml ``` to run the commands. The local inventory is created from ``` ./infra/ansible/config/inventory_tf.yml ```

** Deployment flow **: 

- Validate the Jumphost resource with the inventory file 
- Copy manifest template to the Jumphost VM 
- Run the script create from these templates