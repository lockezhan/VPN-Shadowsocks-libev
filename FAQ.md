# Frequently Asked Questions (FAQ)

## General Questions

### Q: What is Shadowsocks?
A: Shadowsocks is a secure socks5 proxy designed to protect your internet traffic. It's lightweight, fast, and cross-platform.

### Q: Is this legal?
A: Shadowsocks is a legal tool. However, how you use it depends on your local laws. This project is for educational and legitimate privacy purposes only.

### Q: What systems are supported?
A: This installation script supports:
- Ubuntu 18.04, 20.04, 22.04, 24.04 LTS
- Debian 10, 11, 12
- x86_64, ARM64, and ARMv7 architectures

### Q: Can I use this on a Raspberry Pi?
A: Yes! This script supports ARM architectures including Raspberry Pi (ARM64 and ARMv7).

## Installation Questions

### Q: Do I need root access?
A: Yes, the installation script requires root or sudo access to install packages and configure system services.

### Q: How long does installation take?
A: Typically 2-5 minutes on a modern system with good internet connection.

### Q: Can I install on a VPS?
A: Yes! This is actually the most common use case. Works great on AWS, DigitalOcean, Linode, Vultr, etc.

### Q: Will this work behind NAT?
A: The server should have a public IP address. If behind NAT, you'll need to configure port forwarding.

### Q: Can I install multiple times?
A: Re-running the installation will update the configuration. Backup your config first if you want to preserve settings.

## Configuration Questions

### Q: How do I change the password?
A: Edit `/etc/shadowsocks-libev/config.json`, update the password field, and restart:
```bash
sudo nano /etc/shadowsocks-libev/config.json
sudo systemctl restart shadowsocks-libev
```

### Q: How do I change the port?
A: Edit `/etc/shadowsocks-libev/config.json`, update `server_port`, update firewall rules, and restart the service.

### Q: What encryption method should I use?
A: The default `chacha20-ietf-poly1305` is recommended for most users. If your CPU has AES-NI, `aes-256-gcm` is also excellent.

### Q: Can I use multiple ports?
A: Yes, but you'll need to create multiple configuration files and systemd service instances.

### Q: Where is the configuration file?
A: `/etc/shadowsocks-libev/config.json`

### Q: How do I backup my configuration?
A:
```bash
sudo cp /etc/shadowsocks-libev/config.json ~/shadowsocks-backup.json
```

## Connection Questions

### Q: Why can't clients connect?
A: Common issues:
1. Firewall blocking the port
2. Service not running (`sudo systemctl status shadowsocks-libev`)
3. Wrong password/port on client
4. Server IP incorrect

### Q: How many users can connect?
A: Depends on your server resources. A small VPS (1GB RAM) can typically handle 10-50 concurrent users.

### Q: Can multiple people use the same server?
A: Yes! They just need the same connection details (IP, port, password, encryption method).

### Q: Why is the connection slow?
A: Possible causes:
1. Server bandwidth limitations
2. High CPU usage (check with `top`)
3. Network congestion
4. Suboptimal encryption method
5. Server location far from you

### Q: Does this support UDP?
A: Yes, by default the mode is set to `tcp_and_udp`.

## Security Questions

### Q: How secure is Shadowsocks?
A: When properly configured with modern encryption (AEAD ciphers), it's very secure for protecting your traffic.

### Q: Should I use a strong password?
A: Absolutely! Use at least 16 random characters. The install script generates one automatically.

### Q: Can someone detect I'm using Shadowsocks?
A: Advanced traffic analysis might detect patterns. For additional obfuscation, consider using plugins like simple-obfs or v2ray-plugin.

### Q: Should I allow all IPs to connect?
A: For personal use, you can restrict IPs via firewall. For shared use, accept all IPs but use a strong password.

### Q: How often should I change the password?
A: Every 3-6 months for security best practices, or immediately if you suspect compromise.

## Performance Questions

### Q: How can I improve performance?
A: See the [Optimization Guide](docs/OPTIMIZATION.md) for detailed tips. Quick wins:
- Enable TCP BBR
- Use hardware-accelerated encryption
- Increase system limits
- Choose server closer to you

### Q: What's the overhead of encryption?
A: Modern AEAD ciphers add minimal overhead (typically <5%) on modern CPUs.

### Q: Can I disable logging for better performance?
A: Yes, but keep logging enabled initially to diagnose issues. Disable for production high-traffic servers.

## Client Questions

### Q: What clients can I use?
A: See [Client Setup Guide](docs/CLIENT_SETUP.md). Popular options:
- Windows: Shadowsocks-Windows
- macOS: ShadowsocksX-NG
- Linux: shadowsocks-libev or shadowsocks-qt5
- Android: Shadowsocks for Android
- iOS: Shadowrocket, Potatso Lite

### Q: Do I need a client on each device?
A: Yes, each device needs a Shadowsocks client configured with your server details.

### Q: Can I use this with a router?
A: Yes! Many routers support Shadowsocks, especially those running OpenWrt or Merlin firmware.

### Q: How do I configure browsers?
A: Set SOCKS5 proxy to `127.0.0.1:1080` (default local port) or use browser extensions like SwitchyOmega.

## Troubleshooting

### Q: The service won't start, what should I do?
A:
```bash
# Check configuration
sudo ss-server -c /etc/shadowsocks-libev/config.json -t

# Check logs
sudo journalctl -u shadowsocks-libev -n 50

# Check if port is in use
sudo netstat -tuln | grep <your_port>
```

### Q: How do I view logs?
A:
```bash
# Real-time logs
sudo journalctl -u shadowsocks-libev -f

# Recent logs
sudo journalctl -u shadowsocks-libev -n 100
```

### Q: The installation failed, what now?
A: Check:
1. Internet connectivity
2. System is supported (Ubuntu/Debian)
3. Sufficient disk space
4. Review error messages in console

### Q: Can I reinstall if something breaks?
A: Yes:
```bash
sudo bash uninstall.sh
sudo bash install.sh
```

## Maintenance Questions

### Q: How do I update Shadowsocks?
A:
```bash
sudo apt-get update
sudo apt-get upgrade shadowsocks-libev
sudo systemctl restart shadowsocks-libev
```

### Q: How do I uninstall?
A:
```bash
sudo bash uninstall.sh
```

### Q: Do I need to maintain this?
A: Minimal maintenance required:
- Keep system updated
- Monitor logs occasionally
- Rotate passwords periodically
- Check resource usage

### Q: How do I monitor resource usage?
A:
```bash
# CPU and memory
top
htop

# Network
sudo iftop -i eth0
vnstat

# Connections
sudo ss -s
```

## Cost Questions

### Q: What does this cost?
A: The software is free (MIT license). You only pay for:
- VPS hosting ($3-10/month typically)
- Domain name (optional, $10-15/year)

### Q: What VPS specs do I need?
A: Minimum:
- 1 CPU core
- 512MB RAM
- 10GB storage
- 1TB bandwidth/month

Recommended:
- 2 CPU cores
- 1GB RAM
- 20GB SSD
- Unlimited or high bandwidth

### Q: Which VPS provider should I choose?
A: Popular options:
- DigitalOcean
- Vultr
- Linode
- AWS Lightsail
- Google Cloud (with free tier)

Choose based on: location, price, bandwidth, and your needs.

## Advanced Questions

### Q: Can I use this with other tools?
A: Yes, Shadowsocks can work alongside:
- V2Ray
- Nginx
- Caddy
- Other proxies

### Q: Can I set up load balancing?
A: Yes, you can use HAProxy or Nginx to load balance across multiple Shadowsocks servers.

### Q: How do I monitor with Prometheus/Grafana?
A: You'll need to export metrics. Consider using:
- Node Exporter for system metrics
- Custom scripts for Shadowsocks-specific metrics

### Q: Can I use plugins?
A: Yes! Edit the configuration to include plugin parameters. Common plugins:
- simple-obfs: Traffic obfuscation
- v2ray-plugin: Advanced features

### Q: How do I enable obfuscation?
A: Install a plugin and configure it in your config file:
```json
{
    "plugin": "obfs-server",
    "plugin_opts": "obfs=tls"
}
```

## Getting More Help

### Q: Where can I get help?
A: 
1. Check this FAQ
2. Review [documentation](docs/)
3. Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
4. Open an issue on GitHub
5. Check Shadowsocks official documentation

### Q: How do I report bugs?
A: Open an issue on GitHub with:
- System information
- Steps to reproduce
- Error messages
- Log output

### Q: Can I contribute?
A: Yes! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Still Have Questions?

If your question isn't answered here:
1. Check the [official Shadowsocks documentation](https://shadowsocks.org/)
2. Search existing GitHub issues
3. Open a new issue with your question
