{ config, lib, pkgs, ... }:
{
  sops.secrets."wireless/home/WIFI_SSID" = {
    owner = "root";
    group = "root";
    mode = "0400";
  };
  
  sops.secrets."wireless/home/WIFI_PSK" = {
    owner = "root";
    group = "root";
    mode = "0400";
  };

  # Keep logging for testing
  system.activationScripts.testSecrets = ''
    echo "Testing SOPS secrets:"
    echo "SSID file contents:"
    cat ${config.sops.secrets."wireless/home/WIFI_SSID".path} || echo "Failed to read SSID"
    echo "PSK file contents:"
    cat ${config.sops.secrets."wireless/home/WIFI_PSK".path} || echo "Failed to read PSK"
  '';

  networking = {
    wireless.enable = false;  # Disable wpa_supplicant
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Optional: use iwd backend instead of wpa_supplicant
    };
  };

  # Add your user to networkmanager group
  users.users.cameron.extraGroups = [ "networkmanager" ];

  # systemd service to configure wifi on boot
  systemd.services.configure-wireless = {
    description = "Configure wireless networks";
    wantedBy = [ "multi-user.target" ];
    after = [ "NetworkManager.service" ];
    script = ''
      SSID=$(cat ${config.sops.secrets."wireless/home/WIFI_SSID".path})
      PSK=$(cat ${config.sops.secrets."wireless/home/WIFI_PSK".path})
      ${pkgs.networkmanager}/bin/nmcli connection add \
        type wifi \
        con-name "$SSID" \
        ifname "*" \
        ssid "$SSID" \
        wifi-sec.key-mgmt wpa-psk \
        wifi-sec.psk "$PSK"
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}

