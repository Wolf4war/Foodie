#!/bin/bash

# Free Tier optimized deployment script for Foodie application
# This script is designed to work within AWS Free Tier constraints

set -e  # Exit on any error

echo "🆓 Starting Foodie Free Tier Deployment..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_freetier() {
    echo -e "${CYAN}[FREE TIER]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this script from the project root."
    exit 1
fi

# Free Tier memory optimization
print_freetier "Optimizing for t2.micro (1GB RAM)..."

# Check available memory
AVAILABLE_MEMORY=$(free -m | awk 'NR==2{printf "%.0f", $7}')
if [ "$AVAILABLE_MEMORY" -lt 200 ]; then
    print_warning "Low memory detected (${AVAILABLE_MEMORY}MB available)"
    print_status "Clearing cache to free up memory..."
    sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
fi

# Lightweight dependency installation
print_status "Installing dependencies (lightweight mode)..."
npm ci --production --silent

# Skip tests on t2.micro to save resources (uncomment if needed)
if [ -f "/sys/hypervisor/uuid" ] && [ "$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')" -lt "2000000" ]; then
    print_freetier "Skipping tests on t2.micro to conserve memory"
else
    if npm run --silent test --dry-run 2>/dev/null; then
        print_status "Running tests..."
        npm test
    fi
fi

# Build with memory constraints
print_status "Building application (memory-optimized)..."
NODE_OPTIONS="--max-old-space-size=512" npm run build

# Free up memory before Docker operations
print_status "Clearing build cache..."
npm cache clean --force || true

# Check Docker memory usage
print_freetier "Checking Docker resource usage..."
if command -v docker &> /dev/null; then
    DOCKER_IMAGES=$(docker images -q | wc -l)
    if [ "$DOCKER_IMAGES" -gt 5 ]; then
        print_warning "Found $DOCKER_IMAGES Docker images. Cleaning up old images..."
        docker image prune -f
        docker system prune -f
    fi
fi

# Stop existing containers gracefully
print_status "Stopping existing containers..."
docker-compose down --remove-orphans || print_warning "No containers to stop"

# Build with reduced parallel jobs for t2.micro
print_status "Building containers (t2.micro optimized)..."
docker-compose build --parallel 1

# Start containers with memory limits
print_status "Starting containers with resource limits..."
docker-compose up -d

# Wait for application with timeout
print_status "Waiting for application to start (timeout: 60s)..."
timeout=60
counter=0
while [ $counter -lt $timeout ]; do
    if curl -f -s http://localhost:80 > /dev/null 2>&1; then
        break
    fi
    sleep 2
    counter=$((counter + 2))
    echo -n "."
done
echo ""

# Health check
print_status "Performing health check..."
if curl -f -s http://localhost:80 > /dev/null; then
    print_success "Application is responding successfully!"
else
    print_error "Health check failed. Checking container status..."
    docker-compose ps
    print_status "Recent logs:"
    docker-compose logs --tail=10
    
    # Free tier troubleshooting
    print_freetier "Free Tier Troubleshooting:"
    print_freetier "1. Check memory usage: free -h"
    print_freetier "2. Check disk space: df -h"
    print_freetier "3. Consider restarting if memory is full"
    
    exit 1
fi

# Clean up for t2.micro
print_freetier "Performing t2.micro cleanup..."
docker image prune -f
docker container prune -f

# Display resource usage
print_success "🎉 Free Tier Deployment completed successfully!"
echo ""
echo "📊 Resource Usage Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get public IP (AWS specific)
PUBLIC_IP=$(curl -s --max-time 5 http://checkip.amazonaws.com/ 2>/dev/null || echo "Unable to fetch")
echo "🔗 Application URL: http://$PUBLIC_IP"
echo "🏠 Local URL: http://localhost"

# Display container status
echo ""
echo "🐳 Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -5

# System resource usage
echo ""
echo "💻 System Resources (t2.micro limits):"
echo "   Memory: $(free -h | awk '/^Mem:/ {print $3"/"$2}') $(free | awk '/^Mem:/ {printf "(%.1f%% used)", $3/$2*100}')"
echo "   Disk: $(df -h / | awk 'NR==2 {print $3"/"$2" ("$5" used)"}')"
echo "   CPU Load: $(uptime | awk -F'load average:' '{ print $2 }' | awk '{print $1}' | sed 's/,//')"

# Docker resource usage
echo "   Docker Images: $(docker images -q | wc -l)"
echo "   Docker Containers: $(docker ps -q | wc -l) running"

echo ""
echo "🆓 Free Tier Status:"
echo "   Instance Type: t2.micro (1 vCPU, 1GB RAM)"
echo "   Monthly Hours Used: Run 'uptime' to check"
echo "   Storage: 8GB EBS ($(df -h / | awk 'NR==2 {print $5}') used)"

echo ""
echo "💡 Free Tier Tips:"
echo "   • Monitor usage at: https://console.aws.amazon.com/billing/home#/freetier"
echo "   • Stop instance when not needed to save hours"
echo "   • Keep data transfer under 15GB/month"
echo "   • Set billing alerts for unexpected charges"

echo ""
print_success "Your Foodie app is running on AWS Free Tier! 🍕"