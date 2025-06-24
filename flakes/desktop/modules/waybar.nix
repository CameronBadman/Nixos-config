# flakes/desktop/modules/waybar.nix
{ config, lib, pkgs, ... }: {
  # Install waybar
  environment.systemPackages = with pkgs; [
    waybar
    playerctl  # For media controls
  ];

  # Waybar configuration
  environment.etc."hypr/conf.d/waybar.conf".text = ''
    # Launch waybar
    exec-once = waybar &
  '';

  # Enhanced waybar config combining both versions
  environment.etc."xdg/waybar/config".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 30;
    spacing = 2;
    margin-top = 2;
    margin-bottom = 2;
    output = [
      "HDMI-A-1"
      "DP-1"
    ];
    
    modules-left = [ "hyprland/workspaces" "hyprland/window" ];
    modules-center = [ "clock" ];
    modules-right = [
      "mpris"
      "idle_inhibitor"
      "pulseaudio"
      "network"
      "bluetooth"
      "cpu"
      "memory"
      "temperature"
      "battery"
      "tray"
    ];

    "hyprland/workspaces" = {
      disable-scroll = false;
      all-outputs = true;
      format = "{id}";
      sort-by-number = true;
      active-only = false;
      on-click = "activate";
      persistent-workspaces = {
        "HDMI-A-1" = [ 1 2 3 4 5 ];
        "DP-1" = [ 6 7 8 9 10 ];
      };
    };

    "hyprland/window" = {
      max-length = 60;
      separate-outputs = false;
      rewrite = {
        "(.*) — Mozilla Firefox" = " $1";
        "(.*) - Google Chrome" = " $1";
        "(.*) - Visual Studio Code" = "󰨞 $1";
        "(.*) - Spotify" = "󰓇 $1";
      };
    };

    clock = {
      format = " {:%I:%M %p | %a %d %b}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
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
          today = "<span color='#ff9e64'><b>%d</b></span>";
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

    temperature = {
      thermal-zone = 2;
      hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
      critical-threshold = 80;
      format-critical = " {temperatureC}°C";
      format = " {temperatureC}°C";
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
      format-ethernet = "󰈀 {ipaddr}/{cidr}";
      tooltip-format = "{ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 Disconnected";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-bluetooth = "󰂯 {volume}%";
      format-bluetooth-muted = " {icon}";
      format-muted = "󰖁";
      format-source = "{volume}% ";
      format-source-muted = "";
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
      format-disabled = "󰂲";
      format-off = "󰂲";
      on-click = "blueman-manager";
      tooltip = false;
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    
    mpris = {
      format = "{player_icon} {dynamic}";
      format-paused = "{status_icon} {dynamic}";
      player-icons = {
        default = "▶";
        spotify = "󰓇";
        firefox = "󰈹";
      };
      status-icons = {
        paused = "⏸";
      };
      dynamic-order = [ "artist" "title" ];
      dynamic-importance = [ "artist" "title" ];
      dynamic-len = 30;
      max-length = 40;
      on-click = "playerctl play-pause";
      on-click-right = "playerctl next";
      on-click-middle = "playerctl previous";
      on-scroll-up = "playerctl volume 0.05+";
      on-scroll-down = "playerctl volume 0.05-";
    };

    tray = {
      icon-size = 16;
      spacing = 5;
    };
  };

  # Kanagawa-inspired styling with improved functionality
  environment.etc."xdg/waybar/style.css".text = ''
    * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font", "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
        transition-property: background-color;
        transition-duration: 0.3s;
    }

    window#waybar {
        background: rgba(22, 22, 29, 0.9);  /* Kanagawa dark background */
        color: #dcd7ba;  /* Kanagawa foreground */
        border-radius: 0px;
        border-bottom: 2px solid rgba(114, 122, 137, 0.3);  /* Kanagawa comment */
    }

    window#waybar.hidden {
        opacity: 0.2;
    }

    #workspaces button {
        padding: 0 8px;
        margin: 2px 2px;
        color: #727169;  /* Kanagawa comment */
        border-radius: 6px;
        transition: all 0.3s ease;
        background: transparent;
        border-bottom: 3px solid transparent;
        min-width: 30px;  /* Just enough for numbers */
        font-weight: bold;
    }

    #workspaces button.active {
        color: #16161d;  /* Dark text */
        background: #7e9cd8;  /* Kanagawa blue */
        border-radius: 6px;
        min-width: 30px;
        box-shadow: rgba(0, 0, 0, 0.3) 0 2px 4px;
        border-bottom: 3px solid #7fb4ca;  /* Kanagawa light blue */
        font-weight: bold;
    }

    #workspaces button:hover {
        background: rgba(126, 156, 216, 0.2);  /* Kanagawa blue transparent */
        color: #dcd7ba;
        border-radius: 6px;
        border-bottom: 3px solid #7e9cd8;
    }

    #workspaces button.urgent {
        background: #e82424;  /* Kanagawa red */
        color: #dcd7ba;
        animation: blink 1s infinite;
    }

    #window,
    #clock,
    #battery,
    #cpu,
    #memory,
    #temperature,
    #network,
    #pulseaudio,
    #bluetooth,
    #idle_inhibitor,
    #tray,
    #mpris {
        padding: 0 10px;
        margin: 2px 4px;
        color: #dcd7ba;  /* Kanagawa foreground */
        border-radius: 8px;
        background: rgba(54, 54, 68, 0.8);  /* Kanagawa surface */
        border: 1px solid rgba(114, 122, 137, 0.2);
    }

    /* Make the clock module wider */
    #clock {
        min-width: 180px;
        background: rgba(126, 156, 216, 0.15);  /* Kanagawa blue tint */
        border: 1px solid rgba(126, 156, 216, 0.3);
    }

    /* CPU styling */
    #cpu {
        background: rgba(255, 160, 102, 0.15);  /* Kanagawa orange tint */
        border: 1px solid rgba(255, 160, 102, 0.3);
    }

    /* Memory styling */
    #memory {
        background: rgba(154, 217, 177, 0.15);  /* Kanagawa green tint */
        border: 1px solid rgba(154, 217, 177, 0.3);
    }

    /* Temperature styling */
    #temperature {
        background: rgba(255, 158, 100, 0.15);  /* Kanagawa peach tint */
        border: 1px solid rgba(255, 158, 100, 0.3);
    }

    #temperature.critical {
        background: #e82424;  /* Kanagawa red */
        color: #dcd7ba;
        animation: blink 1s infinite;
    }

    /* Battery styling */
    #battery {
        background: rgba(127, 180, 202, 0.15);  /* Kanagawa light blue tint */
        border: 1px solid rgba(127, 180, 202, 0.3);
    }

    #battery.warning {
        background: #c0a36e;  /* Kanagawa yellow */
        color: #16161d;
    }

    #battery.critical {
        background: #e82424;  /* Kanagawa red */
        color: #dcd7ba;
        animation: blink 1s infinite;
    }

    /* Network styling */
    #network {
        background: rgba(147, 153, 178, 0.15);  /* Kanagawa violet tint */
        border: 1px solid rgba(147, 153, 178, 0.3);
    }

    /* Audio styling */
    #pulseaudio {
        background: rgba(214, 188, 249, 0.15);  /* Kanagawa purple tint */
        border: 1px solid rgba(214, 188, 249, 0.3);
    }

    #pulseaudio.muted {
        background: rgba(114, 122, 137, 0.3);  /* Kanagawa comment */
        color: #727169;
    }

    /* Media player styling */
    #mpris {
        padding: 0 12px;
        margin: 2px 4px;
        background: rgba(154, 217, 177, 0.15);  /* Kanagawa green tint */
        border: 1px solid rgba(154, 217, 177, 0.3);
        min-width: 200px;
    }

    /* Bluetooth styling */
    #bluetooth {
        background: rgba(126, 156, 216, 0.15);  /* Kanagawa blue tint */
        border: 1px solid rgba(126, 156, 216, 0.3);
    }

    @keyframes blink {
        to {
            background: transparent;
            color: #dcd7ba;
        }
    }

    tooltip {
        background: rgba(22, 22, 29, 0.95);  /* Kanagawa background */
        border: 1px solid rgba(114, 122, 137, 0.4);
        border-radius: 8px;
    }

    tooltip label {
        color: #dcd7ba;  /* Kanagawa foreground */
        padding: 6px;
    }
  '';
}
