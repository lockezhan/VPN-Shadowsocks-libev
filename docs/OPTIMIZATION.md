# Performance Optimization Guide

## Overview

This guide provides tips and best practices for optimizing Shadowsocks-libev performance.

## System-Level Optimizations

### 1. Kernel Parameters

Edit `/etc/sysctl.conf` or create `/etc/sysctl.d/99-shadowsocks.conf`:

```bash
# Maximum number of open files
fs.file-max = 1024000

# Maximum number of connections
net.core.somaxconn = 1024

# TCP Fast Open
net.ipv4.tcp_fastopen = 3

# TCP BBR congestion control
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# TCP buffer sizes
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864

# Connection tracking
net.netfilter.nf_conntrack_max = 1000000

# Reduce TIME_WAIT connections
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1

# Increase local port range
net.ipv4.ip_local_port_range = 10000 65000
```

Apply changes:
```bash
sudo sysctl -p
```

### 2. System Limits

Edit `/etc/security/limits.conf`:

```
* soft nofile 512000
* hard nofile 1024000
shadowsocks soft nofile 512000
shadowsocks hard nofile 1024000
```

Or create `/etc/systemd/system/shadowsocks-libev.service.d/limits.conf`:

```ini
[Service]
LimitNOFILE=1024000
```

### 3. CPU Affinity

For multi-core systems, pin process to specific cores:

```ini
[Service]
CPUAffinity=0 1 2 3
```

## Shadowsocks Configuration Optimization

### 1. Enable TCP Fast Open

```json
{
    "fast_open": true
}
```

Requires kernel 3.7+ and sysctl setting.

### 2. Disable No Delay

For bulk transfers, allow TCP buffering:

```json
{
    "no_delay": false
}
```

### 3. Enable Port Reuse

```json
{
    "reuse_port": true
}
```

Improves performance on multi-core systems.

### 4. Optimal Timeout

```json
{
    "timeout": 300
}
```

Balance between resource usage and connection persistence.

### 5. Worker Threads

Run multiple workers (requires manual setup):

```bash
# Create multiple service instances
for i in {1..4}; do
    sudo cp /lib/systemd/system/shadowsocks-libev.service \
           /lib/systemd/system/shadowsocks-libev@$i.service
done
```

## Encryption Method Selection

### Performance vs Security

**Fastest to Slowest:**

1. **aes-128-gcm** (with AES-NI)
   - Fastest on modern Intel/AMD CPUs
   - Recommended for high-traffic servers

2. **chacha20-ietf-poly1305**
   - Faster on ARM and systems without AES-NI
   - Better for mobile devices
   - Default recommendation

3. **aes-256-gcm** (with AES-NI)
   - Good security/performance balance
   - Slightly slower than AES-128

### Benchmark Encryption Methods

```bash
# Install iperf3
sudo apt-get install iperf3

# Test different methods
for method in aes-128-gcm chacha20-ietf-poly1305 aes-256-gcm; do
    echo "Testing $method"
    # Run throughput test
done
```

## Network Optimization

### 1. TCP BBR

Enable BBR congestion control (Linux 4.9+):

```bash
# Add to /etc/sysctl.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# Apply
sudo sysctl -p
```

Verify:
```bash
sysctl net.ipv4.tcp_congestion_control
```

### 2. MTU Optimization

Find optimal MTU:

```bash
# Test with ping
ping -M do -s 1472 your_server_ip

# Reduce size until no fragmentation
# Optimal MTU = successful size + 28
```

### 3. IPv6 Support

Enable IPv6 for better routing in some regions:

```json
{
    "server": ["::", "0.0.0.0"]
}
```

## Server Hardware Recommendations

### Minimum Requirements
- CPU: 1 core, 1 GHz
- RAM: 128 MB
- Network: 1 Mbps
- Suitable for: 1-5 users

### Recommended Configuration
- CPU: 2+ cores, 2+ GHz
- RAM: 512 MB - 1 GB
- Network: 100 Mbps+
- Suitable for: 10-50 users

### High-Performance Setup
- CPU: 4+ cores, 3+ GHz with AES-NI
- RAM: 2+ GB
- Network: 1 Gbps+
- SSD storage
- Suitable for: 100+ users

## Load Balancing

### Multiple Server Setup

1. Deploy multiple Shadowsocks servers
2. Use DNS round-robin or load balancer
3. Configure HAProxy or Nginx for load balancing

### HAProxy Example

```
frontend shadowsocks_frontend
    bind *:8388
    mode tcp
    default_backend shadowsocks_backend

backend shadowsocks_backend
    mode tcp
    balance roundrobin
    server ss1 10.0.0.1:8388 check
    server ss2 10.0.0.2:8388 check
    server ss3 10.0.0.3:8388 check
```

## Monitoring Performance

### 1. Real-time Monitoring

```bash
# Network traffic
sudo iftop -i eth0

# Process monitoring
htop

# Connection count
ss -s
```

### 2. Bandwidth Monitoring

```bash
# Install vnStat
sudo apt-get install vnstat

# Monitor bandwidth
vnstat -l
```

### 3. Performance Metrics

```bash
# Test latency
ping server_ip

# Test bandwidth
iperf3 -c server_ip -p server_port

# Test with Shadowsocks
curl --socks5 127.0.0.1:1080 -o /dev/null -s -w "%{time_total}\n" http://example.com
```

## Database Tuning

### Connection Tracking Optimization

```bash
# Increase connection tracking table size
sudo sysctl -w net.netfilter.nf_conntrack_max=1000000

# Reduce timeout
sudo sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=3600
```

## Memory Optimization

### 1. Reduce Memory Usage

If running on low-memory systems:

```json
{
    "no_delay": false,
    "timeout": 60
}
```

### 2. Memory Limits

Limit service memory usage:

```ini
[Service]
MemoryLimit=100M
```

## Disk I/O Optimization

### 1. Disable Logging (Production)

For high-traffic servers:

```ini
[Service]
StandardOutput=null
StandardError=null
```

### 2. Use tmpfs for Logs

```bash
# Add to /etc/fstab
tmpfs /var/log/shadowsocks tmpfs defaults,noatime,size=10M 0 0
```

## Client-Side Optimization

### 1. Local DNS Cache

Use dnsmasq for local DNS caching:

```bash
sudo apt-get install dnsmasq
```

### 2. Multiple Connections

Use multiple local ports for better performance:

```bash
# Start multiple local instances
ss-local -c config1.json -l 1080
ss-local -c config2.json -l 1081
ss-local -c config3.json -l 1082
```

## Benchmark Results

### Typical Performance Metrics

**Low-end VPS (1 core, 512MB RAM):**
- Throughput: 50-100 Mbps
- Concurrent connections: 100-500
- Latency overhead: 5-10ms

**Mid-range VPS (2 cores, 2GB RAM):**
- Throughput: 200-500 Mbps
- Concurrent connections: 1000-5000
- Latency overhead: 2-5ms

**High-end Server (4+ cores, 4GB+ RAM):**
- Throughput: 1+ Gbps
- Concurrent connections: 10000+
- Latency overhead: 1-3ms

## Troubleshooting Performance Issues

### High CPU Usage

1. Check encryption method (use hardware-accelerated cipher)
2. Enable TCP Fast Open
3. Distribute load across multiple cores
4. Consider hardware upgrade

### High Memory Usage

1. Reduce timeout value
2. Limit maximum connections
3. Check for memory leaks (update to latest version)
4. Add swap space (not recommended for production)

### Network Bottlenecks

1. Test raw network performance
2. Check for bandwidth throttling
3. Optimize TCP parameters
4. Consider CDN or edge servers
5. Use better network provider

### Connection Drops

1. Increase timeout value
2. Enable keepalive
3. Check firewall/NAT timeout settings
4. Monitor server resource usage

## Performance Checklist

- [ ] TCP BBR enabled
- [ ] TCP Fast Open enabled
- [ ] Optimal encryption method selected
- [ ] System limits increased
- [ ] Kernel parameters tuned
- [ ] Port reuse enabled
- [ ] Monitoring setup
- [ ] Regular performance tests
- [ ] Resource usage within limits

## Benchmarking Tools

- **iperf3**: Network throughput testing
- **netdata**: Real-time performance monitoring
- **prometheus + grafana**: Long-term metrics
- **speedtest-cli**: Internet speed testing
- **wrk**: HTTP benchmarking tool

## Further Reading

- [Linux Performance Tuning](http://www.brendangregg.com/linuxperf.html)
- [TCP Tuning Guide](https://wwwx.cs.unc.edu/~sparkst/howto/network_tuning.php)
- [BBR Congestion Control](https://cloud.google.com/blog/products/networking/tcp-bbr-congestion-control-comes-to-gcp-your-internet-just-got-faster)
