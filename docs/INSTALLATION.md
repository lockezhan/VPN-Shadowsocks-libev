# Installation Guide

## Prerequisites

- Ubuntu 18.04+ or Debian 10+
- Root or sudo access
- Internet connection
- At least 100MB free disk space

## Quick Installation

### One-Line Installation

```bash
wget -O install.sh https://raw.githubusercontent.com/lockezhan/VPN-Shadowsocks-libev/main/install.sh && sudo bash install.sh
```

Or using curl:

```bash
curl -o install.sh https://raw.githubusercontent.com/lockezhan/VPN-Shadowsocks-libev/main/install.sh && sudo bash install.sh
```

### Step-by-Step Installation

1. **Clone the repository**

```bash
git clone https://github.com/lockezhan/VPN-Shadowsocks-libev.git
cd VPN-Shadowsocks-libev
```

2. **Run the installation script**

```bash
sudo bash install.sh
```

3. **Wait for installation to complete**

The script will:
- Check system compatibility
- Install required dependencies
- Install Shadowsocks-libev
- Generate configuration with random password and port
- Setup and start systemd service

4. **Note the configuration details**

The script will display:
- Server IP address
- Server port
- Password
- Encryption method
- QR code for mobile devices

## Supported Systems

### Ubuntu
- Ubuntu 24.04 LTS (Noble Numbat)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Ubuntu 20.04 LTS (Focal Fossa)
- Ubuntu 18.04 LTS (Bionic Beaver)

### Debian
- Debian 12 (Bookworm)
- Debian 11 (Bullseye)
- Debian 10 (Buster)

### Architectures
- x86_64 / amd64
- ARM64 / aarch64
- ARMv7

## Post-Installation

### Check Service Status

```bash
sudo systemctl status shadowsocks-libev
```

### View Configuration

```bash
sudo cat /etc/shadowsocks-libev/config.json
```

### View Logs

```bash
sudo journalctl -u shadowsocks-libev -f
```

### Restart Service

```bash
sudo systemctl restart shadowsocks-libev
```

## Firewall Configuration

If you have a firewall enabled, allow the Shadowsocks port:

### UFW (Ubuntu)

```bash
sudo ufw allow <port>/tcp
sudo ufw allow <port>/udp
```

Replace `<port>` with your configured port number.

### iptables

```bash
sudo iptables -A INPUT -p tcp --dport <port> -j ACCEPT
sudo iptables -A INPUT -p udp --dport <port> -j ACCEPT
```

## Cloud Provider Setup

### AWS EC2

1. Add inbound rules to Security Group:
   - Type: Custom TCP, Port: your_port, Source: 0.0.0.0/0
   - Type: Custom UDP, Port: your_port, Source: 0.0.0.0/0

### Google Cloud Platform

1. Create firewall rule:
   ```bash
   gcloud compute firewall-rules create shadowsocks \
     --allow tcp:your_port,udp:your_port \
     --source-ranges 0.0.0.0/0
   ```

### DigitalOcean

1. Add inbound rules to Firewall:
   - Protocol: TCP, Port: your_port, Source: All IPv4, All IPv6
   - Protocol: UDP, Port: your_port, Source: All IPv4, All IPv6

## Troubleshooting

### Installation Fails

1. Check system compatibility:
   ```bash
   lsb_release -a
   ```

2. Ensure you have root access:
   ```bash
   sudo -v
   ```

3. Check internet connection:
   ```bash
   ping -c 4 8.8.8.8
   ```

### Service Won't Start

1. Check configuration syntax:
   ```bash
   sudo ss-server -c /etc/shadowsocks-libev/config.json -t
   ```

2. Check port availability:
   ```bash
   sudo netstat -tuln | grep <port>
   ```

3. View detailed logs:
   ```bash
   sudo journalctl -u shadowsocks-libev -n 50 --no-pager
   ```

### Cannot Connect

1. Verify service is running:
   ```bash
   sudo systemctl status shadowsocks-libev
   ```

2. Check firewall rules
3. Verify configuration on client matches server
4. Test port connectivity:
   ```bash
   telnet server_ip server_port
   ```

## Next Steps

- [Configuration Guide](../config/README.md) - Learn about configuration options
- [Client Setup Guide](CLIENT_SETUP.md) - Setup clients on various devices
- [Security Guide](SECURITY.md) - Best practices for secure deployment
- [Optimization Guide](OPTIMIZATION.md) - Performance tuning tips
