#!/bin/bash
#
# Shadowsocks-libev Installation Script for Ubuntu/Debian
# 
# This script automates the installation and configuration of Shadowsocks-libev
# on Ubuntu and Debian systems.
#
# Usage: sudo bash install.sh
#

set -e

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/scripts/common.sh"
source "${SCRIPT_DIR}/scripts/system_check.sh"
source "${SCRIPT_DIR}/scripts/install_deps.sh"
source "${SCRIPT_DIR}/scripts/configure.sh"

# Configuration variables
SS_CONFIG_DIR="/etc/shadowsocks-libev"
SS_SERVICE_FILE="/lib/systemd/system/shadowsocks-libev.service"
SS_USER="nobody"

# Main installation function
main() {
    print_header "Shadowsocks-libev Installation Script"
    
    # Check if running as root
    check_root
    
    # Check system compatibility
    check_system
    
    # Install dependencies
    print_info "Installing dependencies..."
    install_dependencies
    
    # Install Shadowsocks-libev
    print_info "Installing Shadowsocks-libev..."
    install_shadowsocks
    
    # Configure Shadowsocks-libev
    print_info "Configuring Shadowsocks-libev..."
    configure_shadowsocks
    
    # Setup systemd service
    print_info "Setting up systemd service..."
    setup_service
    
    # Enable and start service
    print_info "Enabling and starting service..."
    systemctl enable shadowsocks-libev
    systemctl start shadowsocks-libev
    
    # Print completion message
    print_success "Installation completed successfully!"
    print_info "Configuration file: ${SS_CONFIG_DIR}/config.json"
    print_info "Service status: systemctl status shadowsocks-libev"
    print_info "To modify configuration, edit ${SS_CONFIG_DIR}/config.json and restart the service"
}

# Run main installation
main "$@"
