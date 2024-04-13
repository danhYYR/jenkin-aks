# Overview
This project simulates the typical Kubernetes to create the automatic CI/CD for deploying the applications on the AKS. For this reason, the proposed framework will include:
- Private AKS
- Jenkin for running the CI/CD process
- Application based on the clean architecture
## Infrastructures
The proposed infrastructure will be following the typical of private AKS:
- Vnet with the subnets for assigning the Ipv4 for the AKS's components
- The AKS with the private API server
- Control VM list for managing the deploying process such as Jumphost, Admin VM,...

Not only ultilize the IaC for managing the infrastructure but the project also integrate the Configuration tools for managing the multiple resources on the cloud provider such as the Ansible. From the terraform, the Ansible inventory will be created simultaneous the dynamic and the static options. By this way, you can easilly copy and manage file to the ControlVM list for deployment tasks.