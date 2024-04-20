# Setup Jenkins chart
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
# Deploy Jenkins Statefulsets
kubectl create -f sc_k8s.yaml
helm install jenkins -f values-jenkins_helm.yaml jenkinsci/jenkins
