{ config, lib, pkgs, ... }: {
  # Add the pptxConvert script to your PATH
  home.packages = with pkgs; [
    libreoffice  # Ensure LibreOffice is available
    (writeShellScriptBin "pptxConvert" ''
      #!/bin/bash
      set -euo pipefail
      
      # Check if LibreOffice is available
      if ! command -v libreoffice &> /dev/null; then
          echo "Error: LibreOffice not found in PATH"
          exit 1
      fi
      
      # Check if any PPTX files exist
      shopt -s nullglob
      pptx_files=(*.pptx)
      if [ ''${#pptx_files[@]} -eq 0 ]; then
          echo "No PPTX files found in current directory"
          exit 0
      fi
      
      echo "Converting ''${#pptx_files[@]} PPTX file(s) to PDF..."
      
      # Convert all PPTX files to PDF
      for file in *.pptx; do 
          if [ -f "$file" ]; then
              echo "Converting: $file"
              libreoffice --headless --convert-to pdf "$file"
          fi
      done
      
      echo "Conversion complete!"
    '')
  ];

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
