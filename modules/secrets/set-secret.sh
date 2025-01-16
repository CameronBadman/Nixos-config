# Function to set WiFi credentials
set_wifi_credentials() {
  local SSID=$1
  local PSK=$2

  mkdir -p ~/nixos-config/secrets

  cat > ~/nixos-config/secrets/default.nix <<EOF
{
  wifi = {
    ssid = "${SSID}";
    psk = "${PSK}";
  };
}
EOF

  echo "WiFi credentials for SSID '${SSID}' have been set."
}

# Check if WiFi credentials are being set
if [ "$1" = "wifi" ] && [ $# -eq 3 ]; then
  set_wifi_credentials "$2" "$3"
  exit 0
fi

# Original secret setting logic remains the same
if [ $# -ne 2 ]; then
  echo "Usage:"
  echo "  $0 wifi \"SSID\" \"PASSWORD\""
  echo "  $0 <SECRET_NAME> <SECRET_VALUE>"
  exit 1
fi

SECRET_NAME=$1
SECRET_VALUE=$2

cat > ~/nixos-config/secrets/default.nix <<EOF
{
  ${SECRET_NAME} = "${SECRET_VALUE}";
}
EOF

echo "Secret ${SECRET_NAME} has been set."
