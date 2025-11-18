#!/bin/bash
#
# Dependency installation functions
#

# Update package lists
update_packages() {
    print_info "Updating package lists..."
    apt-get update -qq
}

# Install required dependencies
install_dependencies() {
    update_packages
    
    print_info "Installing required packages..."
    
    # List of required packages
    local packages=(
        "gettext"
        "build-essential"
        "autoconf"
        "libtool"
        "libssl-dev"
        "gawk"
        "debhelper"
        "dh-systemd"
        "init-system-helpers"
        "pkg-config"
        "asciidoc"
        "xmlto"
        "apg"
        "libpcre3-dev"
        "zlib1g-dev"
        "libev-dev"
        "libc-ares-dev"
        "libsodium-dev"
        "libmbedtls-dev"
        "haveged"
        "rng-tools"
        "qrencode"
    )
    
    # Install packages
    DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
    
    print_success "Dependencies installed successfully"
}

# Install Shadowsocks-libev from repository
install_shadowsocks() {
    print_info "Installing Shadowsocks-libev package..."
    
    # Check if shadowsocks-libev is available in repos
    if apt-cache show shadowsocks-libev > /dev/null 2>&1; then
        DEBIAN_FRONTEND=noninteractive apt-get install -y shadowsocks-libev
        print_success "Shadowsocks-libev installed from repository"
    else
        print_warning "Shadowsocks-libev not available in default repositories"
        print_info "Adding official repository..."
        
        # Install from official repository
        install_from_source
    fi
}

# Install from source (fallback method)
install_from_source() {
    print_info "Installing from source..."
    
    local TMP_DIR="/tmp/shadowsocks-build"
    mkdir -p "$TMP_DIR"
    cd "$TMP_DIR"
    
    # Clone repository
    if [ ! -d "shadowsocks-libev" ]; then
        git clone https://github.com/shadowsocks/shadowsocks-libev.git
        cd shadowsocks-libev
        git submodule update --init --recursive
    else
        cd shadowsocks-libev
        git pull
    fi
    
    # Build and install
    ./autogen.sh
    ./configure --prefix=/usr --sysconfdir=/etc
    make
    make install
    
    print_success "Shadowsocks-libev built and installed from source"
    
    cd /
    rm -rf "$TMP_DIR"
}
