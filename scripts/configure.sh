#!/bin/bash
#
# Configuration functions for Shadowsocks-libev
#

# Configure Shadowsocks-libev
configure_shadowsocks() {
    # Create configuration directory
    mkdir -p "$SS_CONFIG_DIR"
    
    # Generate configuration if it doesn't exist
    if [ ! -f "$SS_CONFIG_DIR/config.json" ]; then
        print_info "Generating new configuration..."
        create_config
    else
        print_warning "Configuration file already exists at $SS_CONFIG_DIR/config.json"
        read -p "Do you want to regenerate it? (y/N) " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_config
            create_config
        fi
    fi
    
    # Set proper permissions
    chmod 644 "$SS_CONFIG_DIR/config.json"
}

# Create configuration file
create_config() {
    # Generate random password and port
    local password=$(generate_password 16)
    local port=$(generate_port)
    
    # Get server IP
    local server_ip=$(curl -s -4 ifconfig.me || echo "0.0.0.0")
    
    print_info "Configuration details:"
    echo "  Server: $server_ip"
    echo "  Port: $port"
    echo "  Password: $password"
    echo "  Method: chacha20-ietf-poly1305"
    
    # Create configuration file
    cat > "$SS_CONFIG_DIR/config.json" <<EOF
{
    "server": "0.0.0.0",
    "server_port": $port,
    "password": "$password",
    "timeout": 300,
    "method": "chacha20-ietf-poly1305",
    "fast_open": true,
    "nameserver": "8.8.8.8",
    "mode": "tcp_and_udp"
}
EOF
    
    print_success "Configuration file created at $SS_CONFIG_DIR/config.json"
    
    # Generate QR code for easy mobile configuration
    generate_qr_code "$server_ip" "$port" "$password"
}

# Backup existing configuration
backup_config() {
    local backup_file="$SS_CONFIG_DIR/config.json.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$SS_CONFIG_DIR/config.json" "$backup_file"
    print_info "Backup created: $backup_file"
}

# Generate QR code for mobile configuration
generate_qr_code() {
    local server=$1
    local port=$2
    local password=$3
    local method="chacha20-ietf-poly1305"
    
    # Create ss:// URL
    local ss_url="ss://$(echo -n "$method:$password@$server:$port" | base64 -w 0)"
    
    print_info "Shadowsocks connection URL:"
    echo "$ss_url"
    
    # Generate QR code if qrencode is available
    if command -v qrencode &> /dev/null; then
        echo ""
        print_info "QR Code for mobile devices:"
        qrencode -t ANSIUTF8 "$ss_url"
    fi
}

# Setup systemd service
setup_service() {
    cat > "$SS_SERVICE_FILE" <<'EOF'
[Unit]
Description=Shadowsocks-libev Server Service
After=network.target

[Service]
Type=simple
User=nobody
Group=nogroup
ExecStart=/usr/bin/ss-server -c /etc/shadowsocks-libev/config.json
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    print_success "Systemd service configured"
}
