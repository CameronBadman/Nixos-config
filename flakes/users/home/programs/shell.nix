# home/programs/shell.nix - Shell configuration
{ config, lib, pkgs, ... }: {
  programs.bash = {
    enable = true;
    
    # Aliases
    shellAliases = {
      # Navigation
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      
      # System
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      
      # Modern alternatives
      cat = "bat";
      ls = "eza";
      find = "fd";
      
      # Nix shortcuts
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      hms = "home-manager switch --flake .";
      
      # Tmux
      tm = "tmux";
      tma = "tmux attach";
      tmn = "tmux new-session";
    };
    
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
