{ config, lib, pkgs, ... }: {
  programs.bash = {
    enable = true;
    
    # Custom prompt
    bashrcExtra = ''
      # Kanagawa-inspired prompt
      PS1='\[\033[1;34m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\]:\[\033[1;36m\]\w\[\033[0m\]\$ '
      
      # History settings
      HISTSIZE=10000
      HISTFILESIZE=20000
      HISTCONTROL=ignoreboth
      shopt -s histappend
      
      # Better tab completion
      shopt -s checkwinsize
      shopt -s expand_aliases
      
      # SSH Agent auto-start
      if [ -z "$SSH_AUTH_SOCK" ]; then
          eval "$(ssh-agent -s)" > /dev/null
          ssh-add ~/.ssh/id_ed25519 2>/dev/null || ssh-add ~/.ssh/id_rsa 2>/dev/null
      fi
      
      # FZF settings
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
      
      # Editor settings
      export EDITOR=nvim
      export VISUAL=nvim
      
      # Wayland environment
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
    '';
  };
  
  # Modern shell tools
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    git = true;
    icons = "auto";
  };
  
  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfDark";
      style = "numbers,changes,header";
    };
  };
  
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
  };
  
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}
