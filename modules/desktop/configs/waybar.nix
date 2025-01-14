{ config, lib, pkgs, ... }:
{
  home-manager.users.cameron = { pkgs, ... }: {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = ["hyprland/workspaces" "hyprland/window"];
          modules-center = ["clock"];
          modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "tray"];
          
          "hyprland/workspaces" = {
            format = "{name}";
            sort-by-number = true;
          };
          
          clock = {
            format = "{:%I:%M %p}";
            format-alt = "{:%Y-%m-%d}";
          };
          
          cpu = {
            format = "{usage}% ";
            interval = 1;
          };
          
          memory = {
            format = "{}% ";
          };
          
          battery = {
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
          };
          
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "Connected ";
            format-disconnected = "Disconnected ⚠";
          };
          
          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" ""];
            };
            scroll-step = 1;
            on-click = "pavucontrol";
          };
          
          tray = {
            icon-size = 21;
            spacing = 10;
          };
        };
      };
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background: rgba(21, 18, 27, 0.6);
          color: #cdd6f4;
        }

        #workspaces button {
          padding: 0 5px;
          color: #313244;
          border-radius: 5px;
        }

        #workspaces button.active {
          color: #a6adc8;
          background: #eba0ac;
          border-radius: 5px;
        }

        #workspaces button:hover {
          background: #11111b;
          color: #cdd6f4;
          border-radius: 5px;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #tray {
          padding: 0 10px;
          color: #cdd6f4;
          border-radius: 5px;
          background: #11111b;
          margin: 3px 0px;
        }
      '';
    };
  };
}
