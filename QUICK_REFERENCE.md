# Quick Reference Guide

## Installation

```bash
# One-line installation
wget -O install.sh https://raw.githubusercontent.com/lockezhan/VPN-Shadowsocks-libev/main/install.sh && sudo bash install.sh
```

## Common Commands

### Service Management
```bash
# Start service
sudo systemctl start shadowsocks-libev

# Stop service
sudo systemctl stop shadowsocks-libev

# Restart service
sudo systemctl restart shadowsocks-libev

# Check status
sudo systemctl status shadowsocks-libev

# Enable auto-start on boot
sudo systemctl enable shadowsocks-libev

# Disable auto-start
sudo systemctl disable shadowsocks-libev
```

### View Information
```bash
# View configuration
sudo cat /etc/shadowsocks-libev/config.json

# View password
sudo cat /etc/shadowsocks-libev/config.json | grep password

# View port
sudo cat /etc/shadowsocks-libev/config.json | grep server_port

# View logs (real-time)
sudo journalctl -u shadowsocks-libev -f

# View recent logs
sudo journalctl -u shadowsocks-libev -n 50
```

### Configuration
```bash
# Edit configuration
sudo nano /etc/shadowsocks-libev/config.json

# After editing, restart service
sudo systemctl restart shadowsocks-libev

# Test configuration
ss-server -c /etc/shadowsocks-libev/config.json -t
```

### Firewall
```bash
# UFW - Allow port
sudo ufw allow <port>/tcp
sudo ufw allow <port>/udp

# UFW - Check status
sudo ufw status

# iptables - Allow port
sudo iptables -A INPUT -p tcp --dport <port> -j ACCEPT
sudo iptables -A INPUT -p udp --dport <port> -j ACCEPT

# iptables - List rules
sudo iptables -L -n
```

### Troubleshooting
```bash
# Check if service is running
ps aux | grep ss-server

# Check port is listening
sudo netstat -tuln | grep <port>
# or
sudo ss -tuln | grep <port>

# Test connectivity to server
telnet <server_ip> <port>

# Check system resources
top
htop

# Check disk space
df -h
```

### Updates
```bash
# Update package lists
sudo apt-get update

# Upgrade Shadowsocks
sudo apt-get upgrade shadowsocks-libev

# Restart after update
sudo systemctl restart shadowsocks-libev
```

## Uninstallation

```bash
# Run uninstall script
sudo bash uninstall.sh

# Or manual uninstallation
sudo systemctl stop shadowsocks-libev
sudo systemctl disable shadowsocks-libev
sudo apt-get remove shadowsocks-libev
sudo rm -rf /etc/shadowsocks-libev
```

## Configuration Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| server | 0.0.0.0 | Server address |
| server_port | Random | Server port |
| password | Random | Authentication password |
| timeout | 300 | Connection timeout (seconds) |
| method | chacha20-ietf-poly1305 | Encryption method |
| fast_open | true | TCP Fast Open |
| mode | tcp_and_udp | Protocol mode |

## Client Connection Info

After installation, you need these details for clients:
- **Server IP**: Your server's public IP
- **Port**: From configuration file
- **Password**: From configuration file  
- **Encryption**: chacha20-ietf-poly1305

## Recommended Encryption Methods

1. **chacha20-ietf-poly1305** (Default) - Best for most systems
2. **aes-256-gcm** - Good for systems with AES-NI
3. **aes-128-gcm** - Faster alternative

## Port Recommendations

- **Avoid**: 80, 443, 8080, 8388 (commonly scanned)
- **Recommended**: 10000-65535 (random port)

## Security Checklist

- [ ] Strong random password (16+ characters)
- [ ] Non-standard port
- [ ] Firewall configured
- [ ] System updated
- [ ] Logs monitored
- [ ] Regular backups

## Performance Tips

```bash
# Enable BBR congestion control
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Increase file limits
echo "* soft nofile 51200" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 51200" | sudo tee -a /etc/security/limits.conf
```

## Getting Help

- [Installation Guide](docs/INSTALLATION.md)
- [Client Setup](docs/CLIENT_SETUP.md)
- [Security Guide](docs/SECURITY.md)
- [Optimization Guide](docs/OPTIMIZATION.md)
- [Configuration Details](config/README.md)

## Common Issues

### Service won't start
```bash
# Check configuration syntax
ss-server -c /etc/shadowsocks-libev/config.json -t

# Check logs
sudo journalctl -u shadowsocks-libev -n 50
```

### Can't connect from client
1. Verify service is running
2. Check firewall rules
3. Verify configuration matches on both sides
4. Test port is open: `telnet server_ip port`

### High CPU usage
1. Consider using AES-NI cipher (aes-128-gcm)
2. Enable TCP Fast Open
3. Optimize system parameters

## Quick Test

After installation, test from client:
```bash
# Test SOCKS5 proxy
curl --socks5 127.0.0.1:1080 https://www.google.com

# Check your IP
curl --socks5 127.0.0.1:1080 https://api.ipify.org
```

Should return your server's IP if working correctly.
