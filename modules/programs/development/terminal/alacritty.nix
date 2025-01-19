{ config, lib, pkgs, ... }: {
  home-manager.users.cameron = { pkgs, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";

        terminal = {
          program = "${pkgs.bash}/bin/bash";
          args = [ "--login" ];
        };

        window = {
          padding = {
            x = 5;
            y = 5;
          };
          opacity = 0.9;
          dynamic_title = true;
        };

        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          size = 11.0;
        };

        colors = {
          primary = {
            background = "#1d1f21";
            foreground = "#c5c8c6";
          };
          normal = {
            black = "#1d1f21";
            red = "#cc6666";
            green = "#b5bd68";
            yellow = "#f0c674";
            blue = "#81a2be";
            magenta = "#b294bb";
            cyan = "#8abeb7";
            white = "#c5c8c6";
          };
          bright = {
            black = "#666666";
            red = "#d54e53";
            green = "#b9ca4a";
            yellow = "#e7c547";
            blue = "#7aa6da";
            magenta = "#c397d8";
            cyan = "#70c0b1";
            white = "#eaeaea";
          };
        };

        cursor = {
          style = {
            shape = "Block";
            blinking = "On";
          };
        };

        scrolling = {
          history = 10000;
          multiplier = 3;
        };
      };
    };
  };
}
