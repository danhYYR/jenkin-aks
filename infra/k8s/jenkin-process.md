Initially, the Jenkin will be implemented following the guideline from the Jenkin's documentation [Jenkin Kubernetes](https://www.jenkins.io/doc/book/installing/kubernetes/). The general guideline:

- Create a Namespace

- Create a service account with Kubernetes admin permissions.

- Create local persistent volume for persistent Jenkins data on Pod restarts.

- Create a deployment YAML and deploy it.

- Create a service YAML and deploy it.

## Jenkins Guidelines
The project's cycle can be managed automatic by the CI/CD. This guideline for showing a step by step to integrate the Jenkins to the Kubernetes cloud service.

Initially, we need to seperate the CI/CD tools from the other application by namespace. 

Moreover, in the almost scenario the applications will be stored into the images on the private docker registry and the secret information for the acceessible from the pods/server is neccescarry. For that reason, the serviec account and the RBAC is require for the Jenkins server for managing the other application. 

Consequently, the persistent volume and persitent volume claim is ultilized to mount the pod's path to the partition of disk for stored the data from the Jenkins server. However, this one only stored the data from the specific nodes worker. That is the signature of the PVC and the PV from the Kuberenets. To overcome this one, you can migrated from the depoyment set of the CI/CD's server pods to the statful set type. By this way, the creation of storage class will be automatic created if necessary. 

In conclusion, the deployment and the service is need to be created for mapping the node resource to the pods but it is only accessed from the local kubernetes. The reason is that only map the pod's adddress to the worker node's address which is not published to the Internet. The potential solution is deploying the Load Balancer services to map the pods with the public IP address. This guideline is not describe the manifest of the jenkins componnet. Pleas refer to this [Jenkins-AKS repo](https://github.com/danhYYR/jenkin-aks) for more detail.

![Jenkins server initial step](https://raw.githubusercontent.com/danhYYR/jenkin-aks/main/images/Jenkins-AKS.png)

When the Jenkins server is running, we need to get the intial Admin password which is created from the pods creation. For that reason, you can access to the pods and access to ```/var/jenkins_home/secrets/initialAdminPassword ``` or logging the pod to search the Initial Password. After that, the Jenkins will show you 2 options for config you server:

![Jenkin-setup](https://raw.githubusercontent.com/danhYYR/jenkin-aks/main/images/Jenkin-Login.png)
![Jenkin admin](https://raw.githubusercontent.com/danhYYR/jenkin-aks/main/images/Jenkin-Admin.png)