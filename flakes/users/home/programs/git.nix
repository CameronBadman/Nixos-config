# home/programs/git.nix - Git configuration
{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "CameronBadman";
    userEmail = "cbadwork@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      
      # Better diff and merge
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
      
      # Colors
      color.ui = "auto";
      color.branch = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };
      color.diff = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };
      color.status = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };
    };
    
    # Better diffs with delta
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
  };
  
  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };


  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";  
      };
    };
  };
}



