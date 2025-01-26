{ config, lib, pkgs, ... }: {
  home-manager.users.cameron = { pkgs, ... }: {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30; # Slightly smaller height for a more compact look
          spacing = 2; # Reduced spacing between widgets
          margin-top = 2; # Reduced top margin
          margin-bottom = 2; # Reduced bottom margin

          modules-left = [ "hyprland/workspaces" "hyprland/window" "clock" ];
          modules-center = [ ]; # Center is empty for now
          modules-right = [
            "pulseaudio"
            "network"
            "bluetooth"
            "cider-launcher"
            "cpu"
            "memory"
            "battery"
            "tray"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            sort-by-number = true;
            active-only = false;
            on-click = "activate";
          };

          "hyprland/window" = {
            max-length = 50;
            separate-outputs = true;
          };

          clock = {
            format = " {:%H:%M}";
            format-alt = " {:%d-%m-%Y}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "%B";
                days = "%d";
                weeks = "%V";
                weekdays = "%a";
                today = "<span color='#f38ba8'><b>%d</b></span>";
              };
            };
          };

          cpu = {
            format = "󰻠 {usage}%";
            interval = 1;
            tooltip = true;
          };

          memory = {
            format = "󰍛 {}%";
            tooltip-format = "{used:0.1f}GB used";
          };

          battery = {
            format = "{icon} {capacity}%";
            format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󰚥 {capacity}%";
            states = {
              warning = 30;
              critical = 15;
            };
          };

          network = {
            format-wifi = "󰖩 {essid} ({signalStrength}%)";
            format-ethernet = "󰈀 Connected";
            format-disconnected = "󰖪 Disconnected";
            tooltip-format = "{ifname}: {ipaddr}";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-bluetooth = "󰂯 {volume}%";
            format-muted = "󰖁";
            format-icons = {
              headphone = "󰋋";
              hands-free = "󰂑";
              headset = "󰋎";
              phone = "";
              portable = "󰏲";
              car = "󰄋";
              default = [ "󰕿" "󰖀" "󰕾" ];
            };
            scroll-step = 1;
            on-click = "pavucontrol";
            tooltip-format = "{desc}";
          };

          bluetooth = {
            format = "󰂯";
            on-click = "blueman-manager"; # Open Blueman Manager on click
            tooltip = false;
          };

          cider-launcher = {
            format = "󰎈"; # Music note icon
            on-click = "cider"; # Launch Cider on click
            tooltip = false;
          };

          tray = {
            icon-size = 16; # Smaller icon size for the tray
            spacing = 5; # Reduced spacing between tray icons
          };
        };
      };
      style = ''
                 * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", "Noto Sans", "Sans-Serif";
          font-size: 12px;  /* Ensure semicolon is present */
          min-height: 0;
          transition-property: background-color;
          transition-duration: 0.5s;  /* Ensure semicolon is present */
        }

        window#waybar {
          background: rgba(21, 18, 27, 0.8);
          color: #cdd6f4;
          border-radius: 0px;
          border-bottom: 2px solid rgba(100, 114, 125, 0.2);
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        #workspaces button {
          padding: 0 4px;
          margin: 2px 2px;
          color: #6c7086;
          border-radius: 4px;
          transition: all 0.3s ease;
        }

        #workspaces button.active {
          color: #1e1e2e;
          background: #cba6f7;
          border-radius: 4px;
          min-width: 30px;
          box-shadow: rgba(0, 0, 0, 0.2) 0 0 2px;
        }

        #workspaces button:hover {
          background: #11111b;
          color: #cdd6f4;
          border-radius: 4px;
          box-shadow: rgba(0, 0, 0, 0.2) 0 0 2px;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #bluetooth,
        #cider-launcher,
        #tray {
          padding: 0 8px;
          margin: 2px 3px;
          color: #cdd6f4;
          border-radius: 6px;
          background: #11111b;
          border: 1px solid rgba(100, 114, 125, 0.1);
        }

        #battery.warning {
          background: #f9e2af;
          color: #1e1e2e;
        }

        #battery.critical {
          background: #f38ba8;
          color: #1e1e2e;
          animation: blink 1s infinite;
        }

        @keyframes blink {
          to {
            background: transparent;
            color: #cdd6f4;
          }
        }

        #pulseaudio.muted {
          background: #313244;
          color: #cdd6f4;
        }

        tooltip {
          background: rgba(21, 18, 27, 0.95);
          border: 1px solid rgba(100, 114, 125, 0.2);
          border-radius: 6px;
        }

        tooltip label {
          color: #cdd6f4;
          padding: 4px;
        }
      '';
    };
  };
}
