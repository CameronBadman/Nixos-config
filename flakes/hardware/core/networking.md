# NetworkManager Device Discovery and Configuration Guide

## Quick Device Discovery

### Show All Network Devices

```bash
# Basic device status overview
nmcli device status

# Detailed information for all devices
nmcli device show

# Show only specific device types
nmcli device status | grep wifi
nmcli device status | grep ethernet
```

### Find Your WiFi Device Name

```bash
# Get just the WiFi device name
nmcli device | grep wifi | awk '{print $1}'

# Store in variable for scripts
WIFI_DEVICE=$(nmcli -t -f DEVICE,TYPE device | grep wifi | cut -d: -f1)
echo "WiFi device: $WIFI_DEVICE"
```

## Device Information Commands

### Detailed Device Inspection

```bash
# Show comprehensive details for a specific device
nmcli device show wlan0

# Show all properties (very verbose)
nmcli -f all device show wlan0

# Show device capabilities
nmcli device show wlan0 | grep -i capab
```

### WiFi-Specific Information

```bash
# List available WiFi networks
nmcli device wifi list

# Rescan for networks
nmcli device wifi rescan

# Show WiFi with more details (BSSID, channel, etc.)
nmcli -f ALL device wifi list
```

## System-Level Device Discovery

### Network Interface Information

```bash
# List all network interfaces
ip link show

# Show only UP interfaces
ip link show up

# Get interface details with addresses
ip addr show
```

### Hardware-Level Discovery

```bash
# Show wireless devices
iw dev

# List wireless capabilities
iw list

# PCI network devices
lspci | grep -i network
lspci | grep -i ethernet
lspci | grep -i wireless

# USB network devices
lsusb | grep -i wireless
lsusb | grep -i ethernet
```

## NetworkManager Configuration

### WiFi Network Management

```bash
# Connect to a network (prompts for password)
nmcli device wifi connect "SSID_NAME" --ask

# Connect with password specified
nmcli device wifi connect "SSID_NAME" password "your_password"

# Connect to hidden network
nmcli device wifi connect "HIDDEN_SSID" password "password" hidden yes

# Connect using specific device
nmcli device wifi connect "SSID_NAME" password "password" ifname wlan0
```

### Connection Management

```bash
# Show all saved connections
nmcli connection show

# Show active connections only
nmcli connection show --active

# Delete a saved connection
nmcli connection delete "connection_name"

# Modify connection settings
nmcli connection modify "connection_name" wifi-sec.psk "new_password"

# Bring connection up/down
nmcli connection up "connection_name"
nmcli connection down "connection_name"
```

### Device Control

```bash
# Enable/disable WiFi
nmcli radio wifi on
nmcli radio wifi off

# Enable/disable all networking
nmcli networking on
nmcli networking off

# Restart specific device
nmcli device disconnect wlan0
nmcli device connect wlan0
```

## Advanced Configuration

### Creating Connections Manually

```bash
# Add WiFi connection with specific settings
nmcli connection add \
    type wifi \
    con-name "MyHome" \
    ifname wlan0 \
    ssid "HomeNetwork" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "password123"

# Add static IP configuration
nmcli connection add \
    type wifi \
    con-name "MyOffice" \
    ifname wlan0 \
    ssid "OfficeNetwork" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "office_password" \
    ipv4.method manual \
    ipv4.addresses 192.168.1.100/24 \
    ipv4.gateway 192.168.1.1 \
    ipv4.dns "8.8.8.8,8.8.4.4"
```

### Connection File Locations

NetworkManager stores connections in:

```
/etc/NetworkManager/system-connections/
```

Example connection file format:

```ini
[connection]
id=MyWiFi
type=wifi
autoconnect=true

[wifi]
ssid=MyNetworkName
mode=infrastructure

[wifi-security]
key-mgmt=wpa-psk
psk=your_password_here

[ipv4]
method=auto

[ipv6]
method=auto
```

## Common Device Naming Patterns

### Predictable Network Interface Names

- **WiFi**: `wlan0`, `wlp3s0`, `wlp0s20f3`
- **Ethernet**: `eth0`, `enp2s0`, `eno1`, `enx[mac]`
- **USB WiFi**: `wlx[mac-address]`
- **Virtual**: `tun0`, `tap0`, `br0`

### Naming Convention Breakdown

- `wl` = wireless
- `en` = ethernet
- `p3s0` = PCI bus 3, slot 0
- `o1` = onboard device 1
- `x[mac]` = MAC address based

## Troubleshooting Commands

### Check Device Status

```bash
# Check if device is managed by NetworkManager
nmcli device status

# Check device driver and firmware
dmesg | grep -i firmware
lsmod | grep -i wifi

# Check systemd logs for NetworkManager
journalctl -u NetworkManager.service -f
```

### Reset and Restart

```bash
# Restart NetworkManager service
sudo systemctl restart NetworkManager

# Reset device (disconnect and reconnect)
nmcli device disconnect wlan0
nmcli device connect wlan0

# Full network restart
sudo systemctl restart NetworkManager
nmcli networking off
nmcli networking on
```

### Debug WiFi Issues

```bash
# Check WiFi radio status
nmcli radio wifi

# Check device capabilities
iw dev wlan0 info

# Monitor WiFi events
nmcli monitor

# Check connection details
nmcli connection show "connection_name"
```

## Useful Aliases

Add these to your shell config (`~/.bashrc`, `~/.zshrc`):

```bash
# NetworkManager shortcuts
alias wifi-list='nmcli device wifi list'
alias wifi-connect='nmcli device wifi connect'
alias wifi-status='nmcli device status'
alias wifi-show='nmcli connection show'
alias wifi-scan='nmcli device wifi rescan && nmcli device wifi list'

# Get WiFi device name
alias wifi-device='nmcli device | grep wifi | awk "{print \$1}"'
```

## Example Workflow

1. **Discover your WiFi device**:

   ```bash
   nmcli device status | grep wifi
   ```

2. **Scan for networks**:

   ```bash
   nmcli device wifi list
   ```

3. **Connect to a network**:

   ```bash
   nmcli device wifi connect "YourSSID" --ask
   ```

4. **Verify connection**:
   ```bash
   nmcli connection show --active
   ping -c 3 google.com
   ```

# Create config file

    ```bash

sudo wpa_passphrase "YourNetworkName" "YourPassword" > /tmp/wpa.conf

```

# Connect to the network

sudo wpa_supplicant -B -i wlan0 -c /tmp/wpa.conf

# Get IP address

sudo dhcpcd wlan0
```
