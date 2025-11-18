#!/bin/bash
#
# System compatibility check functions
#

# Detect OS and version
check_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
    else
        print_error "Cannot detect OS version"
        exit 1
    fi
    
    print_info "Detected OS: $OS $VER"
    
    # Check if OS is supported
    case "$OS" in
        ubuntu)
            # Version comparison for Ubuntu (e.g., 18.04, 20.04)
            if [[ "${VER%%.*}" -lt 18 ]]; then
                print_warning "Ubuntu version $VER may not be fully supported. Recommended: 18.04+"
            fi
            ;;
        debian)
            # Version comparison for Debian (e.g., 10, 11, 12)
            if [[ "$VER" -lt 10 ]]; then
                print_warning "Debian version $VER may not be fully supported. Recommended: 10+"
            fi
            ;;
        *)
            print_error "Unsupported OS: $OS. This script only supports Ubuntu and Debian."
            exit 1
            ;;
    esac
    
    # Check system architecture
    ARCH=$(uname -m)
    print_info "System architecture: $ARCH"
    
    case "$ARCH" in
        x86_64|amd64)
            print_success "Architecture supported"
            ;;
        aarch64|arm64)
            print_success "ARM64 architecture detected"
            ;;
        armv7l)
            print_success "ARMv7 architecture detected"
            ;;
        *)
            print_warning "Architecture $ARCH may not be fully supported"
            ;;
    esac
}

# Check network connectivity
check_network() {
    print_info "Checking network connectivity..."
    if ping -c 1 -W 3 8.8.8.8 > /dev/null 2>&1; then
        print_success "Network connectivity OK"
    else
        print_error "No network connectivity detected"
        exit 1
    fi
}

# Check available disk space
check_disk_space() {
    local required_space=100  # MB
    local available_space=$(df /tmp | tail -1 | awk '{print $4}')
    available_space=$((available_space / 1024))  # Convert to MB
    
    if [ $available_space -lt $required_space ]; then
        print_error "Insufficient disk space. Required: ${required_space}MB, Available: ${available_space}MB"
        exit 1
    fi
    print_success "Disk space check passed"
}
