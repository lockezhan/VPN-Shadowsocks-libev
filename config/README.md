# Shadowsocks-libev Configuration Guide

## Configuration File Location

The default configuration file is located at `/etc/shadowsocks-libev/config.json`

## Configuration Parameters

### server
- **Type**: String
- **Description**: Server IP address to bind to
- **Default**: "0.0.0.0" (listens on all interfaces)
- **Example**: "0.0.0.0" or "::0" for IPv6

### server_port
- **Type**: Integer
- **Description**: Server port number
- **Default**: 8388
- **Range**: 1-65535 (recommended: 1024-65535)
- **Example**: 8388

### password
- **Type**: String
- **Description**: Password for authentication
- **Required**: Yes
- **Recommendation**: Use a strong, randomly generated password
- **Example**: "your_very_strong_password"

### timeout
- **Type**: Integer
- **Description**: Connection timeout in seconds
- **Default**: 300
- **Example**: 300

### method
- **Type**: String
- **Description**: Encryption method
- **Recommended**: 
  - chacha20-ietf-poly1305
  - aes-256-gcm
  - aes-128-gcm
- **Example**: "chacha20-ietf-poly1305"

### fast_open
- **Type**: Boolean
- **Description**: Enable TCP Fast Open
- **Default**: true
- **Note**: Requires kernel support (Linux 3.7+)
- **Example**: true

### nameserver
- **Type**: String
- **Description**: DNS server for resolving domain names
- **Default**: "8.8.8.8"
- **Example**: "8.8.8.8" or "1.1.1.1"

### mode
- **Type**: String
- **Description**: Protocol mode
- **Options**: 
  - "tcp_only"
  - "udp_only"
  - "tcp_and_udp"
- **Default**: "tcp_and_udp"
- **Example**: "tcp_and_udp"

## Security Recommendations

1. **Use Strong Passwords**: Generate random passwords with at least 16 characters
2. **Use Modern Encryption**: Prefer AEAD ciphers like chacha20-ietf-poly1305 or aes-256-gcm
3. **Non-Standard Ports**: Avoid common ports like 80, 443, 8080
4. **Firewall Configuration**: Only open necessary ports
5. **Regular Updates**: Keep Shadowsocks-libev updated

## Advanced Options

### plugin
- **Type**: String
- **Description**: Plugin binary path
- **Example**: "obfs-server"

### plugin_opts
- **Type**: String
- **Description**: Plugin options
- **Example**: "obfs=http"

## Example Configurations

### Basic Server Configuration
```json
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "password": "mypassword",
    "timeout": 300,
    "method": "chacha20-ietf-poly1305",
    "mode": "tcp_and_udp"
}
```

### High Security Configuration
```json
{
    "server": "0.0.0.0",
    "server_port": 9999,
    "password": "very_long_and_random_password_here",
    "timeout": 300,
    "method": "chacha20-ietf-poly1305",
    "fast_open": true,
    "nameserver": "1.1.1.1",
    "mode": "tcp_and_udp",
    "no_delay": true,
    "reuse_port": true
}
```

### Configuration with Plugin
```json
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "password": "mypassword",
    "timeout": 300,
    "method": "chacha20-ietf-poly1305",
    "plugin": "obfs-server",
    "plugin_opts": "obfs=http",
    "mode": "tcp_and_udp"
}
```

## Applying Configuration Changes

After modifying the configuration file, restart the service:

```bash
sudo systemctl restart shadowsocks-libev
```

## Verifying Configuration

Check service status:
```bash
sudo systemctl status shadowsocks-libev
```

View logs:
```bash
sudo journalctl -u shadowsocks-libev -f
```
