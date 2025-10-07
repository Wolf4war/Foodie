#!/bin/bash

# Update system
apt-get update && apt-get upgrade -y

# Install essential packages
apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    jq

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Docker Compose standalone (for compatibility)
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Node.js 18 (lightweight installation for t2.micro)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Optimize for t2.micro (1GB RAM)
echo "# Optimize for low memory usage" >> /etc/sysctl.conf
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

# Create swap file for t2.micro (helps with low memory)
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

# Install Nginx
apt-get install -y nginx

# Enable and start services
systemctl enable docker
systemctl start docker
systemctl enable nginx
systemctl start nginx

# Create actions-runner directory for ubuntu user
mkdir -p /home/ubuntu/actions-runner
chown ubuntu:ubuntu /home/ubuntu/actions-runner

# Create a script to set up GitHub Actions runner
cat > /home/ubuntu/setup-runner.sh << 'EOF'
#!/bin/bash

cd /home/ubuntu/actions-runner

# Download the latest runner package
curl -o actions-runner-linux-x64-2.328.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz

# Validate the hash
echo "01066fad3a2893e63e6ca880ae3a1fad5bf9329d60e77ee15f2b97c148c3cd4e  actions-runner-linux-x64-2.328.0.tar.gz" | shasum -a 256 -c

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.328.0.tar.gz

# Make the script executable
chmod +x config.sh
chmod +x run.sh

echo "GitHub Actions runner setup complete!"
echo "To configure the runner, run:"
echo "cd /home/ubuntu/actions-runner"
echo "./config.sh --url ${github_repo_url} --token YOUR_GITHUB_TOKEN"
echo "Then run: ./run.sh"
EOF

chown ubuntu:ubuntu /home/ubuntu/setup-runner.sh
chmod +x /home/ubuntu/setup-runner.sh

# Create systemd service for GitHub Actions runner (template)
cat > /etc/systemd/system/github-actions-runner.service << 'EOF'
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/actions-runner
ExecStart=/home/ubuntu/actions-runner/run.sh
Restart=always
RestartSec=5
KillMode=process
KillSignal=SIGINT
TimeoutStopSec=5min

[Install]
WantedBy=multi-user.target
EOF

# Create a basic nginx configuration for the app
cat > /etc/nginx/sites-available/foodie << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Enable the nginx site
ln -s /etc/nginx/sites-available/foodie /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Test and reload nginx
nginx -t && systemctl reload nginx

# Create a welcome script
cat > /home/ubuntu/welcome.sh << 'EOF'
#!/bin/bash
echo "============================================="
echo "Welcome to your Foodie Ubuntu Server!"
echo "============================================="
echo "Server Information:"
echo "- OS: $(lsb_release -d | cut -f2)"
echo "- Docker: $(docker --version)"
echo "- Node.js: $(node --version)"
echo "- npm: $(npm --version)"
echo "- nginx: $(nginx -v 2>&1)"
echo ""
echo "Next steps:"
echo "1. Set up GitHub Actions runner:"
echo "   cd /home/ubuntu/actions-runner"
echo "   ./config.sh --url ${github_repo_url} --token YOUR_GITHUB_TOKEN"
echo "   ./run.sh"
echo ""
echo "2. Or run the setup script:"
echo "   ./setup-runner.sh"
echo ""
echo "3. Enable runner as a service (after configuration):"
echo "   sudo systemctl enable github-actions-runner"
echo "   sudo systemctl start github-actions-runner"
echo ""
echo "============================================="
EOF

chown ubuntu:ubuntu /home/ubuntu/welcome.sh
chmod +x /home/ubuntu/welcome.sh

# Add welcome script to ubuntu user's bashrc
echo "" >> /home/ubuntu/.bashrc
echo "# Welcome message" >> /home/ubuntu/.bashrc
echo "/home/ubuntu/welcome.sh" >> /home/ubuntu/.bashrc

echo "Server setup completed successfully!"