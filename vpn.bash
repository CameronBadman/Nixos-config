#!/bin/bash

# Automated UQ VPN Connection Script using pipes
# Real-time URL detection and Chrome launching

UQ_USER="s4723961@uq.edu.au"
VPN_SERVER="vpn.uq.edu.au"

echo "🔄 Starting UQ VPN connection process..."
echo "📱 Will automatically open Chrome when auth URL is detected"
echo ""

# Kill any existing openconnect processes
echo "🧹 Cleaning up any existing connections..."
sudo pkill openconnect 2>/dev/null || true
sleep 2

echo "🔍 Monitoring for authentication URL..."
echo "📄 OpenConnect output:"
echo "===================="

# Create a URL monitor function that reads from stdin
url_monitor() {
    while IFS= read -r line; do
        # Print the line so logs are still visible
        echo "$line"
        
        # Check if this line contains the auth URL
        if [[ "$line" == *"Failed to spawn external browser for https://"* ]]; then
            # Extract the URL from the line
            AUTH_URL=$(echo "$line" | grep -o 'https://[^[:space:]]*')
            
            if [ -n "$AUTH_URL" ]; then
                echo ""
                echo "🔗 Authentication URL detected: $AUTH_URL"
                echo "🌐 Opening Chrome automatically..."
                
                # Open Chrome in background
                google-chrome-stable "$AUTH_URL" &
                
                echo "✅ Chrome opened! Complete authentication there."
                echo ""
            fi
        fi
    done
}

# Pipe openconnect output to our URL monitor
sudo openconnect "$VPN_SERVER" --user="$UQ_USER" --external-browser="/bin/echo %s" 2>&1 | url_monitor

echo "===================="
echo ""
read -p "✅ Press Enter after completing authentication in Chrome..."

echo ""
echo "🚀 Establishing VPN connection..."
echo "📄 OpenConnect output:"
echo "===================="

# Now connect with the actual VPN
exec sudo openconnect "$VPN_SERVER" --user="$UQ_USER" --verbose
