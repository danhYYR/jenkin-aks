# Install kubectl
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
# Install az cli
sudo apt update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# Export ServicePrincipal with the enviroment
# Config port connect ssh to 2024
sudo sed -i 's/#Port 22/Port 2024/' /etc/ssh/sshd_config
sudo systemctl restart sshd
