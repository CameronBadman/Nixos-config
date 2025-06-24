{ config, pkgs, lib, ... }:

{
  # Configure Bash with enhanced Git integration
  home-manager.users.cameron = { pkgs, ... }: {
    # Explicitly disable Starship
    programs.starship.enable = false;
    
    # Configure Bash
    programs.bash = {
      enable = true;
      
      # Shell aliases
      # History configuration
      historyControl = ["ignoredups" "ignorespace"];
      historyFileSize = 20000;
      historySize = 10000;
      
      # Shell options
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      
      # Initialize prompt and functions
      initExtra = ''
        # Colors
        RESET="\[\033[0m\]"
        BLACK="\[\033[0;30m\]"
        RED="\[\033[0;31m\]"
        GREEN="\[\033[0;32m\]"
        YELLOW="\[\033[0;33m\]"
        BLUE="\[\033[0;34m\]"
        PURPLE="\[\033[0;35m\]"
        CYAN="\[\033[0;36m\]"
        WHITE="\[\033[0;37m\]"
        BOLD_RED="\[\033[1;31m\]"
        BOLD_GREEN="\[\033[1;32m\]"
        BOLD_YELLOW="\[\033[1;33m\]"
        BOLD_BLUE="\[\033[1;34m\]"
        BOLD_PURPLE="\[\033[1;35m\]"
        BOLD_CYAN="\[\033[1;36m\]"
        BOLD_WHITE="\[\033[1;37m\]"
        
        # Git symbols
        GIT_BRANCH_SYMBOL=" "
        GIT_CHANGED_SYMBOL="+"
        GIT_STAGED_SYMBOL="●"
        GIT_UNTRACKED_SYMBOL="…"
        GIT_AHEAD_SYMBOL="↑"
        GIT_BEHIND_SYMBOL="↓"
        
        # Check if we're in a git repository
        function is_git_repo {
          git rev-parse --is-inside-work-tree &>/dev/null
        }
        
        # Get the current branch name
        function git_branch_name {
          git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
        }
        
        # Get git status information
        function git_status_info {
          if ! is_git_repo; then
            return
          fi
          
          local symbols=""
          local staged_files=$(git diff --staged --name-only 2>/dev/null | wc -l)
          local changed_files=$(git diff --name-only 2>/dev/null | wc -l)
          local untracked_files=$(git ls-files --others --exclude-standard | wc -l)
          
          # Check for staged, changed, and untracked files
          if [[ $staged_files -gt 0 ]]; then
            symbols+="$GIT_STAGED_SYMBOL"
          fi
          if [[ $changed_files -gt 0 ]]; then
            symbols+="$GIT_CHANGED_SYMBOL"
          fi
          if [[ $untracked_files -gt 0 ]]; then
            symbols+="$GIT_UNTRACKED_SYMBOL"
          fi
          
          # Check for ahead/behind
          local ahead_behind=$(git rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)
          if [[ $? -eq 0 ]]; then
            local ahead=$(echo "$ahead_behind" | awk '{print $2}')
            local behind=$(echo "$ahead_behind" | awk '{print $1}')
            if [[ $ahead -gt 0 ]]; then
              symbols+="$GIT_AHEAD_SYMBOL"
            fi
            if [[ $behind -gt 0 ]]; then
              symbols+="$GIT_BEHIND_SYMBOL"
            fi
          fi
          
          echo "$symbols"
        }
        
        # Get git info for prompt
        function git_prompt_info {
          if ! is_git_repo; then
            return
          fi
          
          local branch=$(git_branch_name)
          local status=$(git_status_info)
          
          if [[ -n "$status" ]]; then
            echo "$GIT_BRANCH_SYMBOL$branch $status"
          else
            echo "$GIT_BRANCH_SYMBOL$branch"
          fi
        }
        
        # Check if we're in a nix shell
        function nix_shell_check {
          if [[ -n "$IN_NIX_SHELL" ]]; then
            echo "❄️ "
          fi
        }
        
        # Set the prompt command
        function set_prompt {
          local status=$?
          
          # Status indicator
          if [[ $status -eq 0 ]]; then
            local prompt_char="$BOLD_GREEN➜$RESET"
          else
            local prompt_char="$BOLD_RED✗$RESET"
          fi
          
          # SSH indicator
          local ssh_indicator=""
          if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
            ssh_indicator="🔒 "
          fi
          
          # User, host and directory
          local user_host_dir="$BOLD_YELLOW\u$RESET@$BOLD_PURPLE\h$RESET:$BOLD_BLUE\w$RESET"
          
          # Git info
          local git_info=""
          if is_git_repo; then
            git_info=" $BOLD_CYAN$(git_prompt_info)$RESET"
          fi
          
          # Nix shell info
          local nix_info="$(nix_shell_check)"
          
          # Set the prompt (all on one line)
          PS1="$user_host_dir$git_info $nix_info$prompt_char "
        }
        
        # Set prompt at every command
        PROMPT_COMMAND=set_prompt
        
        # Ensure Starship isn't running
        if type starship &>/dev/null; then
          unset STARSHIP_SHELL
          unset STARSHIP_SESSION_KEY
          PROMPT_COMMAND="$(echo "$PROMPT_COMMAND" | sed 's/starship_precmd;//g')"
        fi
        
        # Make less more friendly for non-text input files
        [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
        
        # Add user bin directory to PATH if it exists
        if [ -d "$HOME/bin" ] ; then
            PATH="$HOME/bin:$PATH"
        fi
        if [ -d "$HOME/.local/bin" ] ; then
            PATH="$HOME/.local/bin:$PATH"
        fi
        
        # Set default editor
        export EDITOR=vim
        
        # Use custom dircolors if it exists
        if [ -f "$HOME/.dircolors" ]; then
            eval "$(dircolors -b $HOME/.dircolors)"
        fi
        
        # Display a message when entering nix-shell
        function nix-shell-hook {
          if [[ "$IN_NIX_SHELL" = "pure" ]]; then
            echo -e "\033[1;34mEntered pure Nix shell\033[0m"
          elif [[ -n "$IN_NIX_SHELL" ]]; then
            echo -e "\033[1;33mEntered impure Nix shell\033[0m"
          fi
        }
        
        # Make sure nix-shell-hook is executed when entering a nix-shell
        if [[ -z "$NIX_SHELL_HOOK_DONE" ]]; then
          export NIX_SHELL_HOOK_DONE=1
          trap "nix-shell-hook" DEBUG
        fi
        
        if test -n "$KITTY_INSTALLATION_DIR"; then
          export KITTY_SHELL_INTEGRATION="no-rc"
          source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
        fi
      '';
    };
  };
  
  # Ensure system-wide Starship is disabled
  programs.starship.enable = false;
}
