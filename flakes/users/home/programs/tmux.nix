# home/programs/tmux.nix - Enhanced Tmux configuration
{ config, lib, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    
    # Custom prefix - space + ctrl (much more comfortable!)
    prefix = "C-Space";
    
    baseIndex = 1;   # Start windows and panes at 1
    keyMode = "vi";  # Vi key bindings
    mouse = true;    # Enable mouse support
    
    # Terminal settings
    terminal = "tmux-256color";
    shell = "${pkgs.bash}/bin/bash";
    
    # Modern plugins for better workflow
    plugins = with pkgs.tmuxPlugins; [
      # Navigation between tmux and vim/nvim
      vim-tmux-navigator
      
      # Better copy mode and search
      tmux-fzf
      
      # Session persistence
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-save-shell-history 'on'
        '';
      }
    ];
    
    extraConfig = ''
      # ===== STATUS LINE POSITION =====
      # Move status line to top
      set -g status-position top
      
      # ===== APPEARANCE =====
      # Muted color scheme to match kitty
      set -g status-bg '#1d1f21'
      set -g status-fg '#c5c8c6'
      set -g status-left-length 50
      set -g status-right-length 100
      
      # Cleaner status bar
      set -g status-left '#[bg=#81a2be,fg=#1d1f21,bold] #{session_name} #[bg=#1d1f21,fg=#81a2be]'
      set -g status-right '#[fg=#666666]#{?client_prefix,#[bg=#cc6666],} %Y-%m-%d #[fg=#c5c8c6]%H:%M #[bg=#81a2be,fg=#1d1f21,bold] #h '
      
      # Window status with better colors
      setw -g window-status-format '#[fg=#666666] #I:#W '
      setw -g window-status-current-format '#[bg=#81a2be,fg=#1d1f21,bold] #I:#W #[bg=#1d1f21,fg=#81a2be]'
      
      # Pane borders (muted)
      set -g pane-border-style 'fg=#666666'
      set -g pane-active-border-style 'fg=#81a2be'
      
      # Message styling
      set -g message-style 'bg=#81a2be,fg=#1d1f21'
      set -g message-command-style 'bg=#f0c674,fg=#1d1f21'
      
      # Copy mode highlighting
      set -g mode-style 'bg=#81a2be,fg=#1d1f21'
      
      # ===== KEYBINDINGS =====
      # Better window splitting (intuitive symbols)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind \\ split-window -h -c "#{pane_current_path}"  # Alternative
      bind _ split-window -v -c "#{pane_current_path}"   # Alternative
      unbind '"'
      unbind %
      
      # New window in current path
      bind c new-window -c "#{pane_current_path}"
      
      # Quick window switching (like browser tabs)
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
      
      # Pane navigation (vim-like)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Pane resizing (repeatable)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # Better pane swapping
      bind > swap-pane -D
      bind < swap-pane -U
      
      # ===== COPY MODE IMPROVEMENTS =====
      # Enter copy mode with space (since prefix is ctrl+space)
      bind Space copy-mode
      bind C-Space copy-mode
      
      # Vi-style copy mode bindings with clipboard integration
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
      bind -T copy-mode-vi Y send-keys -X copy-line
      bind -T copy-mode-vi r send-keys -X rectangle-toggle
      bind -T copy-mode-vi H send-keys -X start-of-line
      bind -T copy-mode-vi L send-keys -X end-of-line
      
      # Paste with prefix+p or prefix+P
      bind p paste-buffer
      bind P choose-buffer
      
      # ===== SESSION MANAGEMENT =====
      # Better session handling
      bind S choose-session
      bind N new-session
      bind X kill-session
      
      # Window management
      bind w choose-window
      bind W command-prompt -p "rename window:" "rename-window '%%'"
      bind R command-prompt -p "rename session:" "rename-session '%%'"
      
      # ===== QUICK ACTIONS =====
      # Quick config reload
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
      
      # Clear screen and history
      bind C-l send-keys 'clear' Enter
      bind C-k clear-history
      
      # Synchronize panes toggle
      bind C-s setw synchronize-panes
      
      # Zoom pane toggle
      bind z resize-pane -Z
      
      # ===== PERFORMANCE & BEHAVIOR =====
      # Faster key repetition
      set -g repeat-time 600
      set -g escape-time 0
      
      # History and display
      set -g history-limit 50000
      set -g display-time 2000
      set -g display-panes-time 3000
      
      # Window and session behavior
      set -g renumber-windows on
      setw -g automatic-rename on
      set -g set-titles on
      set -g set-titles-string '#S:#I:#W - #{pane_title}'
      
      # Activity monitoring (less intrusive)
      setw -g monitor-activity on
      set -g visual-activity off
      set -g activity-action other
      
      # Better focus events
      set -g focus-events on
      
      # True color support
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      
      # ===== MOUSE IMPROVEMENTS =====
      # Better mouse behavior
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M
      
      # Mouse drag to copy
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'wl-copy'
      
      # ===== MODERN WORKFLOW =====
      # Quick pane layouts
      bind M-1 select-layout even-horizontal
      bind M-2 select-layout even-vertical
      bind M-3 select-layout main-horizontal
      bind M-4 select-layout main-vertical
      bind M-5 select-layout tiled
    '';
  };
}
