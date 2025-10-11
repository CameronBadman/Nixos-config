# home/programs/tmux.nix
{ config, lib, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    shell = "${pkgs.bash}/bin/bash";
    escapeTime = 0;
    historyLimit = 50000;
    resizeAmount = 5;
    
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      tmux-fzf
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
      set -g status-position top
      
      set -g status-bg '#16161d'
      set -g status-fg '#dcd7ba'
      set -g status-left-length 50
      set -g status-right-length 100
      
      set -g status-left '#[fg=#7e9cd8,bold]#{session_name} #[fg=#54546d]│ '
      set -g status-right '#[fg=#727169]#{?client_prefix,#[fg=#e82424]⌨ ,}%Y-%m-%d #[fg=#54546d]│ #[fg=#dcd7ba]%H:%M #[fg=#54546d]│ #[fg=#7e9cd8]#h'
      
      # Window tabs with clear grouping using brackets
      setw -g window-status-format ' #[fg=#727169]#I:#[fg=#938aa9]#W #[fg=#54546d]│'
      setw -g window-status-current-format ' #[fg=#7e9cd8,bold]#I:#[fg=#dcd7ba,bold]#W #[fg=#54546d]│'
      
      set -g pane-border-style 'fg=#54546d'
      set -g pane-active-border-style 'fg=#7e9cd8'
      
      set -g message-style 'bg=#7e9cd8,fg=#16161d,bold'
      set -g message-command-style 'bg=#c0a36e,fg=#16161d,bold'
      
      set -g mode-style 'bg=#7e9cd8,fg=#16161d'
      
      setw -g window-status-activity-style 'fg=#e82424'
      setw -g window-status-bell-style 'fg=#e82424,bold'
      
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind \\ split-window -h -c "#{pane_current_path}"
      bind _ split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      bind c new-window -c "#{pane_current_path}"
      
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
      
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      bind > swap-pane -D
      bind < swap-pane -U
      
      bind Space copy-mode
      bind C-Space copy-mode
      
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
      bind -T copy-mode-vi Y send-keys -X copy-line
      bind -T copy-mode-vi r send-keys -X rectangle-toggle
      bind -T copy-mode-vi H send-keys -X start-of-line
      bind -T copy-mode-vi L send-keys -X end-of-line
      
      bind p paste-buffer
      bind P choose-buffer
      
      bind S choose-session
      bind N new-session
      bind X kill-session
      bind w choose-window
      bind W command-prompt -p "rename window:" "rename-window '%%'"
      bind R command-prompt -p "rename session:" "rename-session '%%'"
      
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
      bind C-l send-keys 'clear' Enter
      bind C-k clear-history
      bind C-s setw synchronize-panes
      bind z resize-pane -Z
      
      set -g repeat-time 600
      set -g display-time 2000
      set -g display-panes-time 3000
      set -g renumber-windows on
      setw -g automatic-rename on
      set -g set-titles on
      set -g set-titles-string '#S:#I:#W - #{pane_title}'
      setw -g monitor-activity on
      set -g visual-activity off
      set -g activity-action other
      set -g focus-events on
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'wl-copy'
      
      bind M-1 select-layout even-horizontal
      bind M-2 select-layout even-vertical
      bind M-3 select-layout main-horizontal
      bind M-4 select-layout main-vertical
      bind M-5 select-layout tiled
    '';
  };
}
