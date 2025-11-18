#!/bin/bash
#
# Shadowsocks-libev Uninstallation Script for Ubuntu/Debian
#
# This script removes Shadowsocks-libev and its configuration files
#
# Usage: sudo bash uninstall.sh
#

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/scripts/common.sh"

# Configuration
SS_CONFIG_DIR="/etc/shadowsocks-libev"
SS_SERVICE_FILE="/lib/systemd/system/shadowsocks-libev.service"

# Main uninstallation function
main() {
    print_header "Shadowsocks-libev Uninstallation Script"
    
    # Check if running as root
    check_root
    
    # Stop and disable service
    print_info "Stopping Shadowsocks-libev service..."
    if systemctl is-active --quiet shadowsocks-libev; then
        systemctl stop shadowsocks-libev
    fi
    
    if systemctl is-enabled --quiet shadowsocks-libev 2>/dev/null; then
        systemctl disable shadowsocks-libev
    fi
    
    # Remove service file
    if [ -f "${SS_SERVICE_FILE}" ]; then
        print_info "Removing systemd service file..."
        rm -f "${SS_SERVICE_FILE}"
        systemctl daemon-reload
    fi
    
    # Remove Shadowsocks-libev package
    print_info "Removing Shadowsocks-libev package..."
    apt-get remove -y shadowsocks-libev || true
    apt-get autoremove -y || true
    
    # Ask if configuration should be removed
    read -p "Do you want to remove configuration files in ${SS_CONFIG_DIR}? (y/N) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Removing configuration directory..."
        rm -rf "${SS_CONFIG_DIR}"
        print_success "Configuration files removed"
    else
        print_info "Configuration files preserved in ${SS_CONFIG_DIR}"
    fi
    
    print_success "Uninstallation completed!"
}

# Run main uninstallation
main "$@"
