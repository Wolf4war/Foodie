#!/bin/bash

# Deployment script for Foodie application
# This script can be run manually or used by CI/CD

set -e  # Exit on any error

echo "🚀 Starting Foodie application deployment..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this script from the project root."
    exit 1
fi

# Update system packages (optional, uncomment if needed)
# print_status "Updating system packages..."
# sudo apt update && sudo apt upgrade -y

# Install/update Node.js dependencies
print_status "Installing Node.js dependencies..."
npm ci

# Run tests (if available)
if npm run --silent test --dry-run 2>/dev/null; then
    print_status "Running tests..."
    npm test
else
    print_warning "No tests found, skipping test execution"
fi

# Build the application
print_status "Building application..."
npm run build

# Stop existing Docker containers
print_status "Stopping existing containers..."
docker-compose down || print_warning "No containers to stop"

# Build and start new containers
print_status "Building and starting new containers..."
docker-compose up -d --build

# Wait for the application to be ready
print_status "Waiting for application to start..."
sleep 30

# Health check
print_status "Performing health check..."
if curl -f -s http://localhost:80 > /dev/null; then
    print_success "Application is responding successfully!"
else
    print_error "Health check failed. Application may not be running correctly."
    print_status "Container status:"
    docker-compose ps
    print_status "Recent logs:"
    docker-compose logs --tail=20
    exit 1
fi

# Clean up old Docker images
print_status "Cleaning up old Docker images..."
docker image prune -f

# Display deployment information
print_success "🎉 Deployment completed successfully!"
echo ""
echo "📊 Deployment Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get public IP
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com/ || echo "Unable to fetch public IP")
echo "🔗 Application URL: http://$PUBLIC_IP"
echo "🏠 Local URL: http://localhost"

# Display container status
echo ""
echo "🐳 Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -10

# Display system information
echo ""
echo "💻 System Information:"
echo "   OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo 'Unknown')"
echo "   Uptime: $(uptime -p 2>/dev/null || echo 'Unknown')"
echo "   Memory Usage: $(free -h | awk '/^Mem:/ {print $3"/"$2}' || echo 'Unknown')"
echo "   Disk Usage: $(df -h / | awk 'NR==2 {print $3"/"$2" ("$5" used)"}' || echo 'Unknown')"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_success "Deployment completed! Your Foodie app is now live! 🍕"

# Optional: Send notification (uncomment and configure if needed)
# curl -X POST -H 'Content-type: application/json' \
#     --data '{"text":"🚀 Foodie app deployed successfully!"}' \
#     YOUR_SLACK_WEBHOOK_URL