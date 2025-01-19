{ config, pkgs, lib, ... }: {
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    baseIndex = 1;
    keyMode = "vi";
    shortcut = "Space"; # Changed from "a" to "Space"
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    terminal = "tmux-256color";
    historyLimit = 2000;
    plugins = [ pkgs.tmuxPlugins.tmux-nova ];
    extraConfig = ''
      # Basic Settings
      set -g mouse on
      set -g status-position top
      setw -g aggressive-resize off
      setw -g clock-mode-style 12
      set -g status-keys vi
      # Force 256 colors
      set -g default-terminal "tmux-256color"
      set -sa terminal-features ',xterm-256color:RGB'
      # Vim-style navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      # Changed from C-a to C-Space for last-window
      bind C-Space last-window
      # Vi copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      # Split panes
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      # Status bar styling
      set -g status on
      set -g status-style bg=#4c566a,fg=#d8dee9
      set -g status-position top
      set -g status-justify left
      set -g status-left-length 100
      set -g status-right-length 100
      set -g window-status-format "#[fg=#4c566a,bg=#2e3440]#[fg=#d8dee9,bg=#4c566a] #I #W #[fg=#4c566a,bg=#2e3440]"
      set -g window-status-current-format "#[fg=#89c0d0,bg=#2e3440]#[fg=#2e3540,bg=#89c0d0] #I #W #[fg=#89c0d0,bg=#2e3440]"
      # Nova Configuration
      set -g @nova-nerdfonts true
      set -g @nova-nerdfonts-left ""
      set -g @nova-nerdfonts-right ""
      set -g @nova-status-style-bg "#4c566a"
      set -g @nova-status-style-fg "#d8dee9"
      set -g @nova-status-style-active-bg "#89c0d0"
      set -g @nova-status-style-active-fg "#2e3540"
      set -g @nova-status-style-double-bg "#2d3540"
      set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"
      set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
      set -g @nova-segment-mode-colors "#78a2c1 #2e3440"
      set -g @nova-segment-whoami "#(whoami)@#h"
      set -g @nova-segment-whoami-colors "#78a2c1 #2e3440"
      set -g @nova-rows 0
      set -g @nova-segments-0-left "mode"
      set -g @nova-segments-0-right "whoami"
      # Ensure nova is loaded last
      run-shell ${pkgs.tmuxPlugins.tmux-nova}/share/tmux-plugins/nova/nova.tmux
    '';
  };
  environment.systemPackages = with pkgs; [ tmux ];
}
