# Overview
This project simulates the typical Kubernetes to create the automatic CI/CD for deploying the applications on the AKS. For this reason, the proposed framework will include:
- Private AKS
- Jenkin for running the CI/CD process
- Application based on the clean architecture
# Infrastructures
The proposed infrastructure will be following the typical of private AKS:
- Vnet with the subnets for assigning the Ipv4 for the AKS's components
- The AKS with the private API server
- Control VM list for managing the deploying process such as Jumphost, Admin VM,...
![Private AKS Infrastructure](./images/Jenkins_Infra.svg)
Not only ultilize the IaC for managing the infrastructure but the project also integrate the Configuration tools for managing the multiple resources on the cloud provider such as the Ansible. From the terraform, the Ansible inventory will be created simultaneous the dynamic and the static options. By this way, you can easilly copy and manage file to the ControlVM list for deployment tasks.
# Workflow
In this proposed approach, the infrastructure will be created by IaC and manage the deploy process manually. Since the Private AKS only access the API server from the device in the same Vnet. So we need to connect to the Jumphost for deploying task. However, the Ansible is the solution for this task from your device.

Terraform to create the Infrastructure --> Output the Inventory for Ansible tasks --> Deploying manually by the Ansible-playbook. The detail flow is included:

- ** Developer **: Commit code, prepare docker file and push feature to the repository -> Jenkins server get the trigger -> CI to build the AKS resources -> CD to build the application

- ** Infrastructure management **: Prepare the terraform resources -> Trigger to the repository -> CI build the cloud infrastructures -> Deploy the Jenkins server on AKS 
## Infrastructure as code (IaC) 
This repo is design the terraform command. Please replace your setup of the infra with the tfvars file on ``` infra/tf/tfvars ```. In this setup, you need to implement your configuration of the backend which is stored the tfstate of the infrastructure. You can replace your configuration with your backend.conf file and run file ``` cmd/tf-config.sh```.

In order to run this IaC, you are required the tfvars file, the Enviroment Variable with define the Service Principal with 
```  
TENANT_ID : Tennant ID
SP_ID : Service Principal Object ID 
SP_SECRET: Service Principal client secret
```
This enviroment variables is asked for the config the kubernetes admin in the following step.

## Configuration
The IaC module is also define the ansible playbook for setup the necessary file on the JumpHost VM. The proposed approaches is provided the dynamic inventory template and the local inventory file. 

Moreover, the configuration team can be reused their playbook with the infrastructure output variables. The inventory variable yaml file will be outputed on the ``` infra/tf/module/self_host/variable_file.yml```. From this template, we can ultilize the playbook from ``` infra/ansible/dynamic-host_play.yaml``` with this command: ``` ansible-playbook dynamic-host_plays.yml --extra-var  {your-template-variable-file}" ```.
# Deploy AKS
## Jenkins Helm
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