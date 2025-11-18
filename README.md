# VPN-Shadowsocks-libev

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-18.04%2B-orange.svg)](https://ubuntu.com/)
[![Debian](https://img.shields.io/badge/Debian-10%2B-red.svg)](https://www.debian.org/)

Ubuntu/Debian 上安装 Shadowsocks-libev 的现代化自动化脚本。

[English](#english) | [中文](#中文)

---

## 中文

### 简介

这是一个用于在 Ubuntu 和 Debian 系统上自动安装和配置 Shadowsocks-libev 的现代化脚本集合。该项目提供了简单、安全且可靠的一键安装解决方案。

### 特性

- ✅ **自动化安装**: 一键安装，无需手动配置
- 🔐 **安全配置**: 自动生成强密码和随机端口
- 🚀 **性能优化**: 使用现代加密算法（chacha20-ietf-poly1305）
- 📱 **移动设备支持**: 自动生成二维码，方便移动设备配置
- 🔧 **Systemd 集成**: 完整的服务管理支持
- 📚 **完整文档**: 详细的安装、配置和优化指南
- 🛡️ **安全最佳实践**: 内置安全建议和配置

### 支持的系统

#### Ubuntu
- Ubuntu 24.04 LTS (Noble Numbat)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Ubuntu 20.04 LTS (Focal Fossa)
- Ubuntu 18.04 LTS (Bionic Beaver)

#### Debian
- Debian 12 (Bookworm)
- Debian 11 (Bullseye)
- Debian 10 (Buster)

#### 架构
- x86_64 / amd64
- ARM64 / aarch64
- ARMv7

### 快速安装

#### 使用 wget

```bash
wget -O install.sh https://raw.githubusercontent.com/lockezhan/VPN-Shadowsocks-libev/main/install.sh && sudo bash install.sh
```

#### 使用 curl

```bash
curl -o install.sh https://raw.githubusercontent.com/lockezhan/VPN-Shadowsocks-libev/main/install.sh && sudo bash install.sh
```

#### 从源代码安装

```bash
git clone https://github.com/lockezhan/VPN-Shadowsocks-libev.git
cd VPN-Shadowsocks-libev
sudo bash install.sh
```

### 使用方法

#### 安装后检查

```bash
# 检查服务状态
sudo systemctl status shadowsocks-libev

# 查看配置文件
sudo cat /etc/shadowsocks-libev/config.json

# 查看日志
sudo journalctl -u shadowsocks-libev -f
```

#### 管理服务

```bash
# 启动服务
sudo systemctl start shadowsocks-libev

# 停止服务
sudo systemctl stop shadowsocks-libev

# 重启服务
sudo systemctl restart shadowsocks-libev

# 查看状态
sudo systemctl status shadowsocks-libev
```

#### 卸载

```bash
sudo bash uninstall.sh
```

### 项目结构

```
VPN-Shadowsocks-libev/
├── install.sh              # 主安装脚本
├── uninstall.sh            # 卸载脚本
├── scripts/                # 辅助脚本
│   ├── common.sh          # 通用函数
│   ├── system_check.sh    # 系统检查
│   ├── install_deps.sh    # 依赖安装
│   └── configure.sh       # 配置生成
├── config/                 # 配置文件
│   ├── config.json.example # 配置示例
│   └── README.md          # 配置说明
├── docs/                   # 文档
│   ├── INSTALLATION.md    # 安装指南
│   ├── CLIENT_SETUP.md    # 客户端配置
│   ├── SECURITY.md        # 安全指南
│   └── OPTIMIZATION.md    # 性能优化
├── LICENSE                 # 许可证
├── CHANGELOG.md           # 更新日志
└── README.md              # 本文件
```

### 文档

- [安装指南](docs/INSTALLATION.md) - 详细的安装步骤
- [客户端配置](docs/CLIENT_SETUP.md) - 各平台客户端设置
- [安全指南](docs/SECURITY.md) - 安全最佳实践
- [性能优化](docs/OPTIMIZATION.md) - 性能调优建议
- [配置说明](config/README.md) - 配置参数详解

### 常见问题

#### 如何修改配置？

编辑 `/etc/shadowsocks-libev/config.json`，然后重启服务：

```bash
sudo nano /etc/shadowsocks-libev/config.json
sudo systemctl restart shadowsocks-libev
```

#### 如何查看连接密码？

```bash
sudo cat /etc/shadowsocks-libev/config.json | grep password
```

#### 防火墙如何配置？

```bash
# UFW
sudo ufw allow <port>/tcp
sudo ufw allow <port>/udp

# iptables
sudo iptables -A INPUT -p tcp --dport <port> -j ACCEPT
sudo iptables -A INPUT -p udp --dport <port> -j ACCEPT
```

### 贡献

欢迎提交 Issue 和 Pull Request！

### 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

### 免责声明

本项目仅供学习和研究使用。请遵守当地法律法规，不要用于非法用途。

---

## English

### Introduction

A modern, automated script collection for installing and configuring Shadowsocks-libev on Ubuntu and Debian systems. This project provides a simple, secure, and reliable one-click installation solution.

### Features

- ✅ **Automated Installation**: One-click install with no manual configuration
- 🔐 **Secure Configuration**: Auto-generated strong passwords and random ports
- 🚀 **Performance Optimized**: Modern encryption (chacha20-ietf-poly1305)
- 📱 **Mobile Support**: Auto-generated QR codes for easy mobile setup
- 🔧 **Systemd Integration**: Full service management support
- 📚 **Complete Documentation**: Detailed installation, configuration, and optimization guides
- 🛡️ **Security Best Practices**: Built-in security recommendations

### Supported Systems

#### Ubuntu
- Ubuntu 24.04 LTS (Noble Numbat)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Ubuntu 20.04 LTS (Focal Fossa)
- Ubuntu 18.04 LTS (Bionic Beaver)

#### Debian
- Debian 12 (Bookworm)
- Debian 11 (Bullseye)
- Debian 10 (Buster)

#### Architectures
- x86_64 / amd64
- ARM64 / aarch64
- ARMv7

### Quick Installation

#### Using wget

```bash
wget -O install.sh https://raw.githubusercontent.com/lockezhan/VPN-Shadowsocks-libev/main/install.sh && sudo bash install.sh
```

#### Using curl

```bash
curl -o install.sh https://raw.githubusercontent.com/lockezhan/VPN-Shadowsocks-libev/main/install.sh && sudo bash install.sh
```

#### From source

```bash
git clone https://github.com/lockezhan/VPN-Shadowsocks-libev.git
cd VPN-Shadowsocks-libev
sudo bash install.sh
```

### Usage

#### Post-Installation Check

```bash
# Check service status
sudo systemctl status shadowsocks-libev

# View configuration
sudo cat /etc/shadowsocks-libev/config.json

# View logs
sudo journalctl -u shadowsocks-libev -f
```

#### Service Management

```bash
# Start service
sudo systemctl start shadowsocks-libev

# Stop service
sudo systemctl stop shadowsocks-libev

# Restart service
sudo systemctl restart shadowsocks-libev

# Check status
sudo systemctl status shadowsocks-libev
```

#### Uninstall

```bash
sudo bash uninstall.sh
```

### Project Structure

```
VPN-Shadowsocks-libev/
├── install.sh              # Main installation script
├── uninstall.sh            # Uninstallation script
├── scripts/                # Helper scripts
│   ├── common.sh          # Common functions
│   ├── system_check.sh    # System checks
│   ├── install_deps.sh    # Dependency installation
│   └── configure.sh       # Configuration generation
├── config/                 # Configuration files
│   ├── config.json.example # Example configuration
│   └── README.md          # Configuration guide
├── docs/                   # Documentation
│   ├── INSTALLATION.md    # Installation guide
│   ├── CLIENT_SETUP.md    # Client setup
│   ├── SECURITY.md        # Security guide
│   └── OPTIMIZATION.md    # Performance optimization
├── LICENSE                 # License file
├── CHANGELOG.md           # Changelog
└── README.md              # This file
```

### Documentation

- [Installation Guide](docs/INSTALLATION.md) - Detailed installation steps
- [Client Setup](docs/CLIENT_SETUP.md) - Client configuration for all platforms
- [Security Guide](docs/SECURITY.md) - Security best practices
- [Optimization Guide](docs/OPTIMIZATION.md) - Performance tuning tips
- [Configuration Guide](config/README.md) - Configuration parameters

### FAQ

#### How to modify configuration?

Edit `/etc/shadowsocks-libev/config.json` and restart the service:

```bash
sudo nano /etc/shadowsocks-libev/config.json
sudo systemctl restart shadowsocks-libev
```

#### How to view connection password?

```bash
sudo cat /etc/shadowsocks-libev/config.json | grep password
```

#### How to configure firewall?

```bash
# UFW
sudo ufw allow <port>/tcp
sudo ufw allow <port>/udp

# iptables
sudo iptables -A INPUT -p tcp --dport <port> -j ACCEPT
sudo iptables -A INPUT -p udp --dport <port> -j ACCEPT
```

### Contributing

Issues and Pull Requests are welcome!

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Disclaimer

This project is for educational and research purposes only. Please comply with local laws and regulations. Do not use for illegal purposes.
