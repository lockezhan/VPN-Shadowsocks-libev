# Client Setup Guide

## Overview

This guide explains how to setup Shadowsocks clients on various platforms to connect to your Shadowsocks-libev server.

## Connection Information

You'll need the following information from your server:
- **Server Address**: Your server's IP address or domain name
- **Server Port**: The port number (displayed during installation)
- **Password**: The authentication password (displayed during installation)
- **Encryption Method**: Usually `chacha20-ietf-poly1305`

## Client Downloads

### Windows
- **Shadowsocks-Windows**: https://github.com/shadowsocks/shadowsocks-windows/releases
- Recommended for Windows 7/8/10/11

### macOS
- **ShadowsocksX-NG**: https://github.com/shadowsocks/ShadowsocksX-NG/releases
- Compatible with macOS 10.11+

### Linux
- Install via package manager:
  ```bash
  sudo apt-get install shadowsocks-libev  # Debian/Ubuntu
  ```
- Or use GUI clients like `shadowsocks-qt5`

### Android
- **Shadowsocks for Android**: https://play.google.com/store/apps/details?id=com.github.shadowsocks
- Or download APK from: https://github.com/shadowsocks/shadowsocks-android/releases

### iOS
- **Shadowrocket**: Available on App Store (Paid)
- **Potatso Lite**: Available on App Store (Free)

## Setup Instructions

### Windows Client

1. Download and extract Shadowsocks-Windows
2. Run `Shadowsocks.exe`
3. Right-click the system tray icon
4. Select "Servers" → "Edit Servers"
5. Enter your server information:
   - Server Address
   - Server Port
   - Password
   - Encryption: chacha20-ietf-poly1305
6. Click "OK" to save
7. Right-click the tray icon and select "Enable System Proxy"

#### Using QR Code (Windows)
1. Right-click the system tray icon
2. Select "Servers" → "Scan QRCode from Screen"
3. Display the QR code from server installation
4. The client will automatically configure

### macOS Client

1. Download and install ShadowsocksX-NG
2. Launch the application
3. Click the icon in menu bar
4. Select "Servers" → "Server Preferences"
5. Click "+" to add a new server
6. Enter your server information
7. Click "OK"
8. Enable "Turn Shadowsocks On" from menu bar icon

#### Using QR Code (macOS)
1. Click menu bar icon
2. Select "Scan QR Code from Screen"
3. Display the QR code generated during installation

### Linux Client

#### Command Line (shadowsocks-libev)

1. Create configuration file: `~/.config/shadowsocks/config.json`
   ```json
   {
       "server": "your_server_ip",
       "server_port": your_port,
       "local_address": "127.0.0.1",
       "local_port": 1080,
       "password": "your_password",
       "timeout": 300,
       "method": "chacha20-ietf-poly1305"
   }
   ```

2. Start the client:
   ```bash
   ss-local -c ~/.config/shadowsocks/config.json
   ```

3. Configure system proxy to use SOCKS5 proxy at `127.0.0.1:1080`

#### GUI Client (shadowsocks-qt5)

1. Install: `sudo apt-get install shadowsocks-qt5`
2. Launch and add server with your connection details
3. Connect to the server

### Android Client

1. Install Shadowsocks from Google Play Store
2. Tap "+" to add a profile
3. Select "Manual Settings"
4. Enter server information
5. Tap "✓" to save
6. Tap the paper plane icon to connect

#### Using QR Code (Android)
1. Tap "+" 
2. Select "Scan QR Code"
3. Scan the QR code from server installation

### iOS Client

#### Shadowrocket

1. Purchase and install Shadowrocket from App Store
2. Tap "+" to add a server
3. Select "Type" → "Shadowsocks"
4. Enter server information
5. Tap "Done"
6. Toggle the switch to connect

#### Using QR Code (iOS)
1. Tap "+" in top right
2. Tap "QR Code" icon
3. Scan the QR code from server installation

## Browser Configuration

### Firefox

1. Open Settings → General → Network Settings
2. Select "Manual proxy configuration"
3. SOCKS Host: `127.0.0.1`, Port: `1080`
4. Select "SOCKS v5"
5. Check "Proxy DNS when using SOCKS v5"

### Chrome/Chromium

Use system proxy settings or extensions like:
- SwitchyOmega (Recommended)
- Proxy SwitchySharp

### SwitchyOmega Configuration

1. Install SwitchyOmega extension
2. Create new profile (type: Proxy Profile)
3. Protocol: SOCKS5
4. Server: 127.0.0.1
5. Port: 1080
6. Apply changes and switch to the profile

## Testing Connection

### Test with curl

```bash
curl --socks5 127.0.0.1:1080 https://www.google.com
```

### Check IP Address

```bash
curl --socks5 127.0.0.1:1080 https://api.ipify.org
```

This should return your server's IP address if connected successfully.

## Troubleshooting

### Cannot Connect

1. Verify server is running:
   ```bash
   sudo systemctl status shadowsocks-libev
   ```

2. Check firewall on server
3. Verify connection details match server configuration
4. Test server port accessibility

### Slow Connection

1. Try different encryption methods
2. Enable TCP Fast Open
3. Check server bandwidth and CPU usage
4. Consider using a server closer to your location

### Connection Drops

1. Increase timeout value in configuration
2. Check server stability
3. Verify network stability
4. Try different ports

## Advanced Configuration

### PAC Mode vs Global Mode

- **PAC Mode**: Only routes specific traffic through proxy (Recommended)
- **Global Mode**: Routes all traffic through proxy

### Custom PAC Rules

Create custom rules to decide which domains use the proxy:

```javascript
function FindProxyForURL(url, host) {
    if (shExpMatch(host, "*.google.com")) {
        return "SOCKS5 127.0.0.1:1080";
    }
    return "DIRECT";
}
```

## Security Tips

1. Don't share your server credentials
2. Use strong, unique passwords
3. Regularly update client applications
4. Monitor server logs for suspicious activity
5. Consider changing ports periodically
