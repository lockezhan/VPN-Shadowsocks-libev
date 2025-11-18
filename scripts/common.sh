#!/bin/bash
#
# Common helper functions
#

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_info() {
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

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root"
        exit 1
    fi
}

# Generate random password
generate_password() {
    local length=${1:-16}
    openssl rand -base64 $length | tr -d "=+/" | cut -c1-$length
}

# Generate random port
generate_port() {
    local port
    while true; do
        port=$((RANDOM % 55535 + 10000))
        if ! netstat -tuln | grep -q ":$port "; then
            echo $port
            break
        fi
    done
}
