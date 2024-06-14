#!/bin/bash

# Update package list and install prerequisite packages
sudo apt update
sudo apt install -y curl wget gnupg software-properties-common apt-transport-https ca-certificates lsb-release gnupg2

# Install VIM
sudo apt install vim

# Install NVM and Node.js (latest version)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install node
nvm use node

# Install Yarn
npm install -g yarn

# Install Docker
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install MySQL Server
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Install Google Cloud SDK
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt install -y apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update
sudo apt install -y google-cloud-sdk

# Install Git and GitHub CLI
sudo apt install -y git
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh

# Prompt for Git username and email
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

# Set Git username and email
git config --global user.name "$git_username"
git config --global user.email "$git_email"

# Generate SSH key for GitHub
ssh-keygen -t ed25519 -C "$git_email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Install Chromium
sudo apt install -y chromium-browser

# Install Slack
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.29.149-amd64.deb
sudo apt install -y ./slack-desktop-*.deb
rm slack-desktop-*.deb

# Install Tmux and configure mouse support
sudo apt install -y tmux
echo "set -g mouse on" > ~/.tmux.conf

# Install Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# Install Zsh and Oh My Zsh
sudo apt install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Display SSH key for GitHub
echo "Copy the following SSH key to your GitHub account:"
cat ~/.ssh/id_ed25519.pub

# Final message
echo "Installation completed! Please log out and log back in for all changes to take effect."

