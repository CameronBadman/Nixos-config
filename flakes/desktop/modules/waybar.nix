# flakes/desktop/modules/waybar.nix
{ config, lib, pkgs, ... }: {
  # Install waybar and dependencies
  environment.systemPackages = with pkgs; [
    waybar
    playerctl  # For media controls
    jq         # For JSON processing in custom scripts
  ];

  # Waybar configuration
  environment.etc."hypr/conf.d/waybar.conf".text = ''
    # Launch waybar
    exec-once = waybar &
  '';

  # Custom scripts for application status
  environment.etc."waybar/scripts/spotify-status.sh" = {
    text = ''
      #!/bin/sh
      if pgrep -x "spotify" > /dev/null; then
        echo '{"text": "󰓇", "class": "running", "tooltip": "Spotify is running - Click to focus"}'
      else
        echo '{"text": "󰓇", "class": "stopped", "tooltip": "Spotify is not running - Click to launch"}'
      fi
    '';
    mode = "0755";
  };

  environment.etc."waybar/scripts/discord-status.sh" = {
    text = ''
      #!/bin/sh
      if pgrep -x "legcord" > /dev/null; then
        # Try to get notification count from window title
        TITLE=$(hyprctl clients -j | jq -r '.[] | select(.class=="legcord") | .title' 2>/dev/null)
        
        if echo "$TITLE" | grep -q "([0-9]\+)"; then
          # Extract number from title like "Legcord (3)"
          COUNT=$(echo "$TITLE" | sed -n 's/.*(\([0-9]\+\)).*/\1/p')
          echo "{\"text\": \"󰙯 $COUNT\", \"class\": \"running notifications\", \"tooltip\": \"Legcord: $COUNT unread messages\"}"
        else
          echo '{"text": "󰙯", "class": "running", "tooltip": "Legcord is running - Click to focus"}'
        fi
      else
        echo '{"text": "󰙯", "class": "stopped", "tooltip": "Legcord is not running - Click to launch"}'
      fi
    '';
    mode = "0755";
  };

  environment.etc."waybar/scripts/spotify-toggle.sh" = {
    text = ''
      #!/bin/sh
      if pgrep -x "spotify" > /dev/null; then
        # Focus Spotify window if running
        hyprctl dispatch focuswindow "class:Spotify"
      else
        # Launch Spotify if not running
        spotify &
      fi
    '';
    mode = "0755";
  };

  environment.etc."waybar/scripts/discord-toggle.sh" = {
    text = ''
      #!/bin/sh
      if pgrep -x "legcord" > /dev/null; then
        # Focus Legcord window if running
        hyprctl dispatch focuswindow "class:legcord"
      else
        # Launch Legcord if not running
        legcord &
      fi
    '';
    mode = "0755";
  };

  # Complete waybar config with FIXED workspace handling + Spotify/Discord integration
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
      "custom/spotify"
      "custom/discord"
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
      all-outputs = false;  # CHANGED: Only show workspaces for current monitor
      format = "{id}";
      sort-by-number = true;
      active-only = false;
      on-click = "activate";
      # REMOVED persistent-workspaces - let Hyprland handle it
    };

    "hyprland/window" = {
      max-length = 60;
      separate-outputs = true;  # CHANGED: Separate window titles per monitor
      rewrite = {
        "(.*) - Google Chrome" = " $1";
        "nvim (.*)" = " $1";
        "(.*) - Spotify" = "󰓇 $1";
        "(.*) - Legcord" = "󰙯 $1";
      };
    };

    # Custom Spotify module
    "custom/spotify" = {
      format = "{}";
      return-type = "json";
      exec = "/etc/waybar/scripts/spotify-status.sh";
      on-click = "/etc/waybar/scripts/spotify-toggle.sh";
      interval = 5;
      tooltip = true;
    };

    # Custom Discord module  
    "custom/discord" = {
      format = "{}";
      return-type = "json";
      exec = "/etc/waybar/scripts/discord-status.sh";
      on-click = "/etc/waybar/scripts/discord-toggle.sh";
      interval = 5;
      tooltip = true;
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

    # Temperature module - flexible configuration
    temperature = {
      # Try thermal zone first (most compatible)
      thermal-zone = 0;
      # Fallback hwmon paths - comment out if thermal-zone works
      # hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
      critical-threshold = 80;
      format-critical = " {temperatureC}°C";
      format = " {temperatureC}°C";
      interval = 2;
      tooltip = true;
      tooltip-format = "CPU Temperature: {temperatureC}°C";
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
      interval = 30;
    };

    network = {
      format-wifi = "󰖩 {essid} ({signalStrength}%)";
      format-ethernet = "󰈀 {ipaddr}/{cidr}";
      tooltip-format = "{ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 Disconnected";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
      interval = 5;
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
      format-connected = "󰂱 {num_connections}";
      on-click = "blueman-manager";
      tooltip-format = "{status}";
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
      tooltip-format-activated = "Idle inhibitor: ON";
      tooltip-format-deactivated = "Idle inhibitor: OFF";
    };
    
    mpris = {
      format = "{player_icon} {dynamic}";
      format-paused = "{status_icon} {dynamic}";
      player-icons = {
        default = "▶";
        spotify = "󰓇";
        firefox = "󰈹";
        chromium = "";
        vlc = "󰕼";
      };
      status-icons = {
        paused = "⏸";
        stopped = "⏹";
      };
      dynamic-order = [ "artist" "title" ];
      dynamic-importance = [ "artist" "title" ];
      dynamic-len = 30;
      max-length = 40;
      interval = 1;
      on-click = "playerctl play-pause";
      on-click-right = "playerctl next";
      on-click-middle = "playerctl previous";
      on-scroll-up = "playerctl volume 0.05+";
      on-scroll-down = "playerctl volume 0.05-";
      tooltip-format = "{player}: {artist} - {title}";
    };

    tray = {
      icon-size = 16;
      spacing = 5;
      tooltip = true;
    };
  };

  # Complete Kanagawa-inspired styling including temperature + Spotify/Discord
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
    #mpris,
    #custom-spotify,
    #custom-discord {
        padding: 0 10px;
        margin: 2px 4px;
        color: #dcd7ba;  /* Kanagawa foreground */
        border-radius: 8px;
        background: rgba(54, 54, 68, 0.8);  /* Kanagawa surface */
        border: 1px solid rgba(114, 122, 137, 0.2);
    }

    /* Spotify integration styling */
    #custom-spotify {
        background: rgba(30, 215, 96, 0.15);  /* Spotify green tint */
        border: 1px solid rgba(30, 215, 96, 0.3);
        font-size: 14px;
        min-width: 25px;
        padding: 0 8px;
    }

    #custom-spotify.running {
        background: rgba(30, 215, 96, 0.25);  /* More opaque when running */
        border: 1px solid rgba(30, 215, 96, 0.5);
        color: #1ed760;  /* Spotify green */
        font-weight: bold;
    }

    #custom-spotify.stopped {
        background: rgba(114, 122, 137, 0.15);  /* Kanagawa comment tint */
        border: 1px solid rgba(114, 122, 137, 0.3);
        color: #727169;  /* Muted color when stopped */
    }

    #custom-spotify:hover {
        background: rgba(30, 215, 96, 0.3);
        color: #1ed760;
    }

    /* Discord integration styling */
    #custom-discord {
        background: rgba(88, 101, 242, 0.15);  /* Discord blurple tint */
        border: 1px solid rgba(88, 101, 242, 0.3);
        font-size: 14px;
        min-width: 25px;
        padding: 0 8px;
    }

    #custom-discord.running {
        background: rgba(88, 101, 242, 0.25);  /* More opaque when running */
        border: 1px solid rgba(88, 101, 242, 0.5);
        color: #5865f2;  /* Discord blurple */
        font-weight: bold;
    }

    #custom-discord.notifications {
        background: rgba(232, 36, 36, 0.3);  /* Red background for notifications */
        border: 1px solid rgba(232, 36, 36, 0.6);
        color: #e82424;  /* Kanagawa red */
        font-weight: bold;
        animation: pulse 2s infinite;
    }

    #custom-discord.stopped {
        background: rgba(114, 122, 137, 0.15);  /* Kanagawa comment tint */
        border: 1px solid rgba(114, 122, 137, 0.3);
        color: #727169;  /* Muted color when stopped */
    }

    #custom-discord:hover {
        background: rgba(88, 101, 242, 0.3);
        color: #5865f2;
    }

    /* Window title styling */
    #window {
        background: rgba(147, 153, 178, 0.15);  /* Kanagawa violet tint */
        border: 1px solid rgba(147, 153, 178, 0.3);
        min-width: 200px;
    }

    /* Clock module styling */
    #clock {
        min-width: 180px;
        background: rgba(126, 156, 216, 0.15);  /* Kanagawa blue tint */
        border: 1px solid rgba(126, 156, 216, 0.3);
        font-weight: bold;
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

    /* Temperature styling - COMPLETE STYLING */
    #temperature {
        background: rgba(255, 158, 100, 0.15);  /* Kanagawa peach tint */
        border: 1px solid rgba(255, 158, 100, 0.3);
        font-weight: bold;
    }

    #temperature.critical {
        background: #e82424;  /* Kanagawa red */
        color: #dcd7ba;
        animation: blink 1s infinite;
        font-weight: bold;
    }

    /* Battery styling */
    #battery {
        background: rgba(127, 180, 202, 0.15);  /* Kanagawa light blue tint */
        border: 1px solid rgba(127, 180, 202, 0.3);
    }

    #battery.warning {
        background: #c0a36e;  /* Kanagawa yellow */
        color: #16161d;
        font-weight: bold;
    }

    #battery.critical {
        background: #e82424;  /* Kanagawa red */
        color: #dcd7ba;
        animation: blink 1s infinite;
        font-weight: bold;
    }

    /* Network styling */
    #network {
        background: rgba(147, 153, 178, 0.15);  /* Kanagawa violet tint */
        border: 1px solid rgba(147, 153, 178, 0.3);
    }

    #network.disconnected {
        background: rgba(232, 36, 36, 0.15);  /* Kanagawa red tint */
        border: 1px solid rgba(232, 36, 36, 0.3);
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

    #mpris.paused {
        background: rgba(114, 122, 137, 0.15);  /* Kanagawa comment tint */
        border: 1px solid rgba(114, 122, 137, 0.3);
    }

    /* Bluetooth styling */
    #bluetooth {
        background: rgba(126, 156, 216, 0.15);  /* Kanagawa blue tint */
        border: 1px solid rgba(126, 156, 216, 0.3);
    }

    #bluetooth.disabled {
        background: rgba(114, 122, 137, 0.15);  /* Kanagawa comment tint */
        border: 1px solid rgba(114, 122, 137, 0.3);
        color: #727169;
    }

    /* Idle inhibitor styling */
    #idle_inhibitor {
        background: rgba(192, 163, 110, 0.15);  /* Kanagawa yellow tint */
        border: 1px solid rgba(192, 163, 110, 0.3);
    }

    #idle_inhibitor.activated {
        background: #c0a36e;  /* Kanagawa yellow */
        color: #16161d;
        font-weight: bold;
    }

    /* Tray styling */
    #tray {
        background: rgba(54, 54, 68, 0.8);  /* Kanagawa surface */
        border: 1px solid rgba(114, 122, 137, 0.2);
    }

    @keyframes blink {
        0% {
            opacity: 1;
        }
        50% {
            opacity: 0.3;
        }
        100% {
            opacity: 1;
        }
    }

    @keyframes pulse {
        0% {
            opacity: 1;
        }
        50% {
            opacity: 0.7;
        }
        100% {
            opacity: 1;
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
        font-size: 11px;
    }
  '';
}
