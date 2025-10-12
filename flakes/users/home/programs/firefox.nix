{ config, lib, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      bookmarks = [
        {
          name = "Quick Access";
          toolbar = true;
          bookmarks = [
            {
              name = "UQ Dashboard";
              url = "https://my.uq.edu.au/";
            }
            {
              name = "Discord";
              url = "https://discord.com/app";
            }
          ];
        }
      ];
      
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        privacy-badger
        sponsorblock
      ];
      
      search = {
        default = "ddg";
        force = true;
        engines = {
          "Google".metaData.hidden = true;
        };
      };
      
      settings = {
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "browser.discovery.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.startup.homepage" = "about:blank";
        
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
        
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };
      
      userChrome = ''
        :root {
          --kanagawa-bg: rgba(31, 31, 40, 0.85) !important;
          --kanagawa-darker: rgba(22, 22, 29, 0.9) !important;
          --kanagawa-wave: #223249 !important;
          --kanagawa-fg: #dcd7ba !important;
        }
        
        #urlbar {
          background-color: var(--kanagawa-bg) !important;
          backdrop-filter: blur(12px) saturate(1.5) !important;
          border-radius: 12px !important;
          border: 1px solid var(--kanagawa-wave) !important;
          padding: 4px 8px !important;
          color: var(--kanagawa-fg) !important;
        }
        
        #navigator-toolbox {
          background-color: var(--kanagawa-darker) !important;
          backdrop-filter: blur(20px) !important;
          border: none !important;
        }
        
        .toolbar-items {
          background-color: transparent !important;
        }
        
        #TabsToolbar {
          background-color: transparent !important;
        }
        
        .tabbrowser-tab[selected] .tab-background {
          background-color: var(--kanagawa-wave) !important;
          border-radius: 8px 8px 0 0 !important;
        }
        
        .tabbrowser-tab:hover .tab-background {
          background-color: rgba(126, 156, 216, 0.15) !important;
        }
        
        .tab-text {
          color: var(--kanagawa-fg) !important;
        }
        
        #urlbar-input {
          color: var(--kanagawa-fg) !important;
        }
      '';
    };
  };
}
