#!/bin/bash

# AWS Free Tier Usage Monitor
# This script helps track your AWS Free Tier usage to avoid unexpected charges

echo "🆓 AWS Free Tier Usage Monitor"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_good() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_alert() {
    echo -e "${RED}🚨 $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

echo ""
echo "📊 Current System Usage:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Instance information
INSTANCE_TYPE=$(curl -s --max-time 2 http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null || echo "Unknown")
INSTANCE_ID=$(curl -s --max-time 2 http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null || echo "Unknown")
AZ=$(curl -s --max-time 2 http://169.254.169.254/latest/meta-data/placement/availability-zone 2>/dev/null || echo "Unknown")

echo "🖥️  Instance Type: $INSTANCE_TYPE"
if [ "$INSTANCE_TYPE" = "t2.micro" ]; then
    print_good "Free Tier eligible instance type"
else
    print_alert "NOT a Free Tier instance type! This will incur charges."
fi

echo "🆔 Instance ID: $INSTANCE_ID"
echo "🌍 Availability Zone: $AZ"

# Uptime (Free Tier: 750 hours/month = ~31.25 days)
UPTIME_DAYS=$(uptime -p | grep -o '[0-9]\+ day' | grep -o '[0-9]\+' || echo "0")
UPTIME_HOURS=$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | grep -o '[0-9]\+:[0-9]\+' | awk -F':' '{print $1}' || echo "0")
TOTAL_HOURS=$((UPTIME_DAYS * 24 + UPTIME_HOURS))

echo ""
echo "⏰ Uptime Analysis:"
echo "   Current uptime: $(uptime -p)"
echo "   Total hours: $TOTAL_HOURS"

if [ "$TOTAL_HOURS" -lt 600 ]; then
    print_good "Well within Free Tier limits (750 hours/month)"
elif [ "$TOTAL_HOURS" -lt 720 ]; then
    print_warning "Approaching Free Tier monthly limit"
else
    print_alert "Exceeding Free Tier monthly hours!"
fi

# Memory usage
echo ""
echo "💾 Memory Usage (t2.micro: 1GB total):"
MEMORY_INFO=$(free -h | awk '/^Mem:/ {print "   Used: "$3" / Available: "$7" / Total: "$2}')
MEMORY_PERCENT=$(free | awk '/^Mem:/ {printf "%.1f", $3/$2*100}')
echo "$MEMORY_INFO"

if (( $(echo "$MEMORY_PERCENT < 70" | bc -l) )); then
    print_good "Memory usage healthy ($MEMORY_PERCENT%)"
elif (( $(echo "$MEMORY_PERCENT < 85" | bc -l) )); then
    print_warning "Memory usage moderate ($MEMORY_PERCENT%)"
else
    print_alert "High memory usage ($MEMORY_PERCENT%)!"
fi

# Disk usage (Free Tier: 30GB EBS)
echo ""
echo "💿 Storage Usage (Free Tier: 30GB EBS):"
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3"/"$2" ("$5" used)"}')
DISK_PERCENT=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
echo "   Root disk: $DISK_USAGE"

if [ "$DISK_PERCENT" -lt 70 ]; then
    print_good "Disk usage within limits"
elif [ "$DISK_PERCENT" -lt 85 ]; then
    print_warning "Moderate disk usage"
else
    print_alert "High disk usage - consider cleanup"
fi

# Docker usage
echo ""
echo "🐳 Docker Resource Usage:"
if command -v docker &> /dev/null; then
    DOCKER_IMAGES=$(docker images -q | wc -l)
    DOCKER_CONTAINERS=$(docker ps -q | wc -l)
    DOCKER_SIZE=$(docker system df --format "{{.Size}}" 2>/dev/null | head -1 || echo "Unknown")
    
    echo "   Images: $DOCKER_IMAGES"
    echo "   Running containers: $DOCKER_CONTAINERS"
    echo "   Docker space used: $DOCKER_SIZE"
    
    if [ "$DOCKER_IMAGES" -gt 10 ]; then
        print_warning "Many Docker images - consider cleanup: docker image prune -f"
    fi
else
    echo "   Docker not installed"
fi

# Network usage estimation
echo ""
echo "🌐 Network Usage:"
if [ -f /proc/net/dev ]; then
    # Get network interface (usually eth0 on EC2)
    INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$INTERFACE" ]; then
        TX_BYTES=$(cat /proc/net/dev | grep "$INTERFACE:" | awk '{print $10}')
        TX_MB=$((TX_BYTES / 1024 / 1024))
        echo "   Outbound data (estimated): ${TX_MB} MB"
        
        if [ "$TX_MB" -lt 10240 ]; then  # 10GB
            print_good "Well within Free Tier data transfer (15GB/month)"
        elif [ "$TX_MB" -lt 14336 ]; then  # 14GB
            print_warning "Approaching Free Tier data transfer limit"
        else
            print_alert "Near or over Free Tier data transfer limit!"
        fi
    fi
fi

echo ""
echo "💡 Free Tier Optimization Tips:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "• Stop instance when not needed: sudo shutdown -h now"
echo "• Monitor usage: https://console.aws.amazon.com/billing/home#/freetier"
echo "• Set billing alerts for $1+ charges"
echo "• Clean Docker images: docker system prune -f"
echo "• Keep outbound data under 15GB/month"

echo ""
echo "🔍 Useful Commands:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "• Check this report: ./monitor-freetier.sh"
echo "• Clean Docker: docker system prune -af"
echo "• Check processes: htop or top"
echo "• Monitor network: sudo nethogs"
echo "• Free memory: sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches"

echo ""
print_info "Run this script regularly to monitor your Free Tier usage!"

# Create a simple cron job suggestion
echo ""
echo "📅 Schedule regular monitoring (optional):"
echo "   Add to crontab: crontab -e"
echo "   Add line: 0 */6 * * * /home/ubuntu/monitor-freetier.sh"