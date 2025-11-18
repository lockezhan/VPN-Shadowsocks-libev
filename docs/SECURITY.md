# Security Best Practices

## Overview

This guide covers security best practices for running a Shadowsocks-libev server.

## Server Security

### 1. Strong Authentication

#### Use Strong Passwords
- Minimum 16 characters
- Use random generation tools
- Include mixed case, numbers, and special characters
- Never use dictionary words or personal information

```bash
# Generate a strong password
openssl rand -base64 24
```

#### Regular Password Rotation
- Change passwords every 3-6 months
- Use different passwords for different services
- Keep secure backup of passwords

### 2. Encryption Methods

#### Recommended Ciphers
Use AEAD (Authenticated Encryption with Associated Data) ciphers:

1. **chacha20-ietf-poly1305** (Recommended)
   - Fast on systems without AES hardware acceleration
   - Strong security
   - Good performance

2. **aes-256-gcm**
   - Excellent on systems with AES-NI
   - Industry standard
   - Very secure

3. **aes-128-gcm**
   - Good balance of speed and security
   - Faster than AES-256
   - Still very secure

#### Avoid Legacy Ciphers
Do not use:
- aes-256-cfb
- aes-192-cfb
- aes-128-cfb
- rc4-md5
- salsa20
- chacha20

These are vulnerable to various attacks.

### 3. Network Security

#### Firewall Configuration

Only open necessary ports:

```bash
# UFW example
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow <shadowsocks_port>/tcp
sudo ufw allow <shadowsocks_port>/udp
sudo ufw enable
```

#### Rate Limiting

Protect against brute force attacks:

```bash
# iptables example
sudo iptables -A INPUT -p tcp --dport <port> -m state --state NEW -m recent --set
sudo iptables -A INPUT -p tcp --dport <port> -m state --state NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
```

#### Fail2ban Integration

Create `/etc/fail2ban/filter.d/shadowsocks.conf`:

```ini
[Definition]
failregex = ERROR.*failed.*<HOST>
ignoreregex =
```

Create `/etc/fail2ban/jail.d/shadowsocks.conf`:

```ini
[shadowsocks]
enabled = true
port = <your_port>
filter = shadowsocks
logpath = /var/log/syslog
maxretry = 5
bantime = 3600
```

### 4. Port Configuration

#### Use Non-Standard Ports
- Avoid common ports: 80, 443, 8080, 8388
- Use random ports: 10000-65535
- Reduces automated scanning

```bash
# Generate random port
shuf -i 10000-65535 -n 1
```

#### Port Knocking (Advanced)
Implement port knocking for additional security layer.

### 5. System Hardening

#### Keep System Updated

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
```

#### Disable Unused Services

```bash
# List running services
systemctl list-units --type=service --state=running

# Disable unnecessary services
sudo systemctl disable <service_name>
```

#### SSH Security

```bash
# Edit /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222  # Change default port
```

### 6. Monitoring and Logging

#### Enable Logging

Shadowsocks-libev logs to syslog by default. Monitor logs:

```bash
# Real-time monitoring
sudo journalctl -u shadowsocks-libev -f

# View recent logs
sudo journalctl -u shadowsocks-libev -n 100
```

#### Setup Log Rotation

Create `/etc/logrotate.d/shadowsocks`:

```
/var/log/shadowsocks.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
```

#### Monitor Resource Usage

```bash
# Check CPU and memory usage
top
htop

# Monitor network connections
sudo netstat -tunap | grep ss-server
```

### 7. Access Control

#### Limit User Access

Run service as dedicated user:

```bash
# Create shadowsocks user
sudo useradd -r -s /bin/false shadowsocks

# Update service file
User=shadowsocks
Group=shadowsocks
```

#### IP Whitelisting (Optional)

For private servers, whitelist specific IPs:

```bash
# iptables example
sudo iptables -A INPUT -p tcp --dport <port> -s <client_ip> -j ACCEPT
sudo iptables -A INPUT -p tcp --dport <port> -j DROP
```

## Client Security

### 1. Secure Client Configuration

- Store configuration files securely
- Use file permissions to protect configs:
  ```bash
  chmod 600 ~/.config/shadowsocks/config.json
  ```

### 2. DNS Leaks

Prevent DNS leaks:
- Enable "Proxy DNS" in client
- Use DNS-over-HTTPS (DoH) or DNS-over-TLS (DoT)
- Verify no DNS leaks at: https://dnsleaktest.com

### 3. Traffic Analysis Protection

#### Use obfuscation plugins
- simple-obfs
- v2ray-plugin

Example with simple-obfs:
```json
{
    "server": "0.0.0.0",
    "server_port": 443,
    "password": "password",
    "method": "chacha20-ietf-poly1305",
    "plugin": "obfs-server",
    "plugin_opts": "obfs=tls"
}
```

## Advanced Security

### 1. Multiple Ports

Run multiple instances on different ports:

```bash
# Create multiple config files
/etc/shadowsocks-libev/config-port1.json
/etc/shadowsocks-libev/config-port2.json

# Create multiple service files
/etc/systemd/system/shadowsocks-libev@.service
```

### 2. Traffic Obfuscation

Use plugins to disguise traffic:

#### simple-obfs
Disguises traffic as HTTP or TLS

#### v2ray-plugin
More advanced obfuscation with WebSocket support

### 3. Intrusion Detection

#### Install AIDE (Advanced Intrusion Detection Environment)

```bash
sudo apt-get install aide
sudo aideinit
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```

#### Setup Tripwire

Monitor file integrity:
```bash
sudo apt-get install tripwire
sudo tripwire --init
```

## Incident Response

### 1. Detecting Compromise

Signs of compromise:
- Unusual network traffic
- High CPU/memory usage
- Unknown processes
- Modified configuration files
- Unusual log entries

### 2. Response Steps

If compromised:

1. Disconnect server from internet
2. Change all passwords
3. Review logs for attack vectors
4. Restore from clean backup
5. Apply security updates
6. Re-harden the system
7. Monitor closely after restoration

### 3. Regular Security Audits

#### Monthly Checks
- Review logs for anomalies
- Check for unauthorized users
- Verify configuration integrity
- Update software packages
- Review firewall rules

#### Quarterly Checks
- Full security audit
- Password rotation
- Review access logs
- Update documentation
- Test backup restoration

## Security Checklist

- [ ] Strong, random password (16+ characters)
- [ ] AEAD cipher (chacha20-ietf-poly1305 or aes-256-gcm)
- [ ] Non-standard port
- [ ] Firewall configured
- [ ] System updated
- [ ] SSH hardened
- [ ] Logging enabled
- [ ] Regular backups
- [ ] Monitoring setup
- [ ] Documentation current

## Resources

- [Shadowsocks Security Tips](https://shadowsocks.org/en/wiki/Troubleshooting.html)
- [OWASP Server Security](https://owasp.org/www-project-secure-headers/)
- [Linux Security Checklist](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server)
- [UFW Guide](https://help.ubuntu.com/community/UFW)

## Reporting Security Issues

If you discover a security vulnerability, please email: security@example.com

Do not open public issues for security vulnerabilities.
