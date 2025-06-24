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

  networking = {
    wireless.enable = false;  # Disable wpa_supplicant
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; 
    };
  };

  users.users.cameron.extraGroups = [ "networkmanager" ];
  
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

  # Fixed portal configuration
  services.dbus.enable = true;  # Keep this!
  services.dbus.packages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland  # Match with extraPortals
  ];
  
  services.upower.enable = true;
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland  # Now matches dbus.packages
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["hyprland"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
    };
  };
}
