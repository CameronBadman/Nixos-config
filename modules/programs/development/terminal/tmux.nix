# tmux.nix for NixOS with integrated home-manager
{ config, pkgs, lib, ... }:

{
  # Ensure tmux and dependencies are installed
  environment.systemPackages = with pkgs; [
    tmux
    tmuxp  # tmux session manager
  ];
  
  # Configure tmux using home-manager
  home-manager.users.cameron = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
      terminal = "screen-256color";
      
      # Add plugins
      plugins = with pkgs.tmuxPlugins; [
        sensible       # Sensible defaults
        resurrect      # Session restore
        continuum      # Auto-save sessions
        prefix-highlight # Show when prefix is active
        {
          plugin = yank;
          extraConfig = ''
            set -g @yank_selection_mouse 'clipboard'
          '';
        }
        # Optional: include fzf if available in your nixpkgs
        # fzf
      ];
      
      extraConfig = ''
        # Change prefix to Ctrl + Space
        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix
        
        # Terminal settings for true color and transparency
        set -ga terminal-overrides ",xterm-256color:Tc"
        set -g default-terminal "screen-256color"
        
        # Enable true transparency (works with terminals that support it)
        set -g window-style "bg=default"
        set -g window-active-style "bg=default"
        
        # Set pane base index
        setw -g pane-base-index 1
        
        # Enable window renumbering
        set -g renumber-windows on
        
        # Enable mouse support
        set -g mouse on
        
        # Splitting Panes with More Intuitive Bindings
        bind '|' split-window -h -c "#{pane_current_path}"
        bind '-' split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %
        
        # Create new windows with current path
        bind c new-window -c "#{pane_current_path}"
        
        # Pane Navigation
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D
        
        # Pane Resizing
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5
        
        # Reload Configuration
        bind r source-file ~/.config/tmux/tmux.conf \; display "Tmux configuration reloaded!"
        
        # Kanagawa Color Scheme with transparency
        # Status Bar
        set -g status-position top
        set -g status-bg "#1F1F28"
        set -g status-fg "#DCD7BA"
        
        # Use nerd fonts for enhanced status bar
        # Status Left with nerd font icons
        set -g status-left "#[fg=#7E9CD8,bg=#1F1F28,bold]  #S #{prefix_highlight} #[default] "
        set -g status-left-length 30
        
        # Status Right with nerd font icons for time and date
        set -g status-right-length 80
        set -g status-right "#[fg=#7AA89F]  %Y-%m-%d #[fg=#7E9CD8]  %H:%M #[default]"
        
        # Window Status - Authentic Kanagawa theme with nerd fonts
        set -g window-status-current-format "#[fg=#DCD7BA,bg=#2D4F67,bold]  #I:#W#{?window_zoomed_flag,  ,} #[default]"
        set -g window-status-format "#[fg=#727169]  #I:#W #[default]"
        
        # Pane Border Colors - Pure Kanagawa theme
        set -g pane-border-style "fg=#545464"
        set -g pane-active-border-style "fg=#E6C384"
        
        # Message Style
        set -g message-style "bg=#1F1F28,fg=#DCD7BA"
        
        # Mode Style (for copy mode)
        setw -g mode-style "bg=#223249,fg=#DCD7BA"
        
        # Copy Mode bindings
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
        
        # Quick session switching back and forth with Space
        bind-key Space switch-client -l
        
        # Session management keybindings
        # S - List sessions and switch to selected
        bind-key S choose-session
        
        # Ctrl+s - Save session with resurrect
        bind-key C-s run-shell "#{@resurrect-save-path}/save.sh"
        
        # Ctrl+r - Restore session with resurrect
        bind-key C-r run-shell "#{@resurrect-path}/scripts/restore.sh"
        
        # n - Create new named session
        bind-key n command-prompt -p "New session name:" "new-session -s '%%'"
        
        # X - Kill current session and move to next
        bind-key X confirm-before -p "Kill session #S? (y/n)" "run-shell 'tmux switch-client -n \\\; kill-session -t \"#S\"'"
        
        # Display pane numbers for longer
        set -g display-panes-time 2000
        
        # Set escape time to 0 for faster command sequences
        set -sg escape-time 0
        
        # Increase scrollback buffer size
        set -g history-limit 20000
        
        # Set window notifications
        setw -g monitor-activity on
        set -g visual-activity off
        
        # Status bar update interval
        set -g status-interval 5
        
        # Configure resurrect plugin
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-strategy-nvim 'session'
        
        # Theme for prefix highlight
        set -g @prefix_highlight_fg '#DCD7BA'
        set -g @prefix_highlight_bg '#2D4F67'
        set -g @prefix_highlight_show_copy_mode 'on'
        set -g @prefix_highlight_copy_mode_attr 'fg=#1F1F28,bg=#E6C384'
      '';
    };
    
    # Configure tmuxp for session management
    home.file.".config/tmuxp/default.yaml" = {
      text = ''
        session_name: main
        windows:
          - window_name: home
            panes:
              - shell_command: neofetch
      '';
    };
    
    # Install patched Nerd Fonts using the new namespace approach
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      tmuxp  # Add tmuxp to user packages too
    ];
  };
}
