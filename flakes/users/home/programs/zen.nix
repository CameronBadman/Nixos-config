# flakes/users/home/programs/zen.nix
{ config, lib, pkgs, zen-browser, ... }: {
  # Enable zen browser using the home manager module
  programs.zen-browser = {
    enable = true;
    
    # Browser policies for enhanced functionality and theming
    policies = {
      # Disable automatic updates (managed by Nix)
      DisableAppUpdate = true;
      
      # Privacy and security settings
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      DisablePasswordReveal = true;
      
      # Performance settings
      HardwareAcceleration = true;
      
      # Extension management
      ExtensionSettings = {
        # uBlock Origin - essential ad blocker
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # Bitwarden (if you use it)
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      
      # Homepage and startup configuration
      Homepage = {
        URL = "about:home";
        Locked = false;
        StartPage = "homepage";
      };
      
      # Search settings
      SearchBar = "unified";
      
      # Download directory
      DownloadDirectory = "\${home}/Downloads";
      
      # Preferences for dark theme, Wayland optimization, and Kanagawa theming
      Preferences = {
        # === Dark Mode Settings ===
        "ui.systemUsesDarkTheme" = true;
        "browser.theme.dark-private-windows" = false;
        "browser.theme.toolbar-theme" = 0; # Dark
        "devtools.theme" = "dark";
        
        # === Wayland Optimizations ===
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "gfx.x11-egl.force-enabled" = true;
        
        # === Performance Tweaks ===
        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;
        "browser.cache.disk.enable" = true;
        "browser.cache.memory.enable" = true;
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        
        # === Privacy Enhancements ===
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state" = true;
        "network.cookie.sameSite.noneRequiresSecure" = true;
        "browser.safebrowsing.malware.enabled" = true;
        "browser.safebrowsing.phishing.enabled" = true;
        
        # === UI Customizations ===
        "browser.tabs.firefox-view" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","downloads-button","library-button","ublock0_raymondhill_net-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar"],"currentVersion":17,"newElementCount":2}'';
        
        # === Kanagawa Color Theme via userChrome.css ===
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        
        # === Font Settings ===
        "font.name.serif.x-western" = "Noto Serif";
        "font.name.sans-serif.x-western" = "Inter";
        "font.name.monospace.x-western" = "JetBrains Mono";
      };
    };
  };
  
  # Custom CSS for Kanagawa theme
  home.file.".zen/chrome/userChrome.css".text = ''
    /* Kanagawa Dark Theme for Zen Browser */
    :root {
      /* Kanagawa Color Palette */
      --kanagawa-bg: #1f1f28;
      --kanagawa-bg-light: #2a2a37;
      --kanagawa-bg-dark: #16161d;
      --kanagawa-fg: #dcd7ba;
      --kanagawa-fg-dark: #c8c093;
      --kanagawa-red: #c34043;
      --kanagawa-orange: #ffa066;
      --kanagawa-yellow: #c0a36e;
      --kanagawa-green: #76946a;
      --kanagawa-teal: #7aa89f;
      --kanagawa-blue: #7e9cd8;
      --kanagawa-purple: #957fb8;
      --kanagawa-pink: #d27e99;
      --kanagawa-gray: #54546d;
    }
    
    /* Main Browser Background */
    #main-window,
    #navigator-toolbox,
    #TabsToolbar,
    #nav-bar,
    #PersonalToolbar {
      background-color: var(--kanagawa-bg) !important;
      color: var(--kanagawa-fg) !important;
    }
    
    /* Tabs */
    .tabbrowser-tab {
      background-color: var(--kanagawa-bg-dark) !important;
      color: var(--kanagawa-fg-dark) !important;
      border-color: var(--kanagawa-gray) !important;
    }
    
    .tabbrowser-tab[selected="true"] {
      background-color: var(--kanagawa-bg-light) !important;
      color: var(--kanagawa-fg) !important;
      border-bottom: 2px solid var(--kanagawa-blue) !important;
    }
    
    .tabbrowser-tab:hover:not([selected="true"]) {
      background-color: var(--kanagawa-bg-light) !important;
      color: var(--kanagawa-fg) !important;
    }
    
    /* URL Bar */
    #urlbar,
    #urlbar-background,
    #urlbar-input-container {
      background-color: var(--kanagawa-bg-dark) !important;
      color: var(--kanagawa-fg) !important;
      border: 1px solid var(--kanagawa-gray) !important;
      border-radius: 6px !important;
    }
    
    #urlbar:focus-within {
      border-color: var(--kanagawa-blue) !important;
      box-shadow: 0 0 0 1px var(--kanagawa-blue) !important;
    }
    
    /* Buttons */
    .toolbarbutton-1 {
      fill: var(--kanagawa-fg) !important;
      color: var(--kanagawa-fg) !important;
    }
    
    .toolbarbutton-1:hover {
      background-color: var(--kanagawa-bg-light) !important;
      border-radius: 4px !important;
    }
    
    /* Context Menus */
    menupopup,
    menuitem,
    menu {
      background-color: var(--kanagawa-bg-light) !important;
      color: var(--kanagawa-fg) !important;
      border: 1px solid var(--kanagawa-gray) !important;
    }
    
    menuitem:hover,
    menu:hover {
      background-color: var(--kanagawa-blue) !important;
      color: var(--kanagawa-bg) !important;
    }
    
    /* Sidebar */
    #sidebar-box,
    #sidebar-header,
    #sidebar {
      background-color: var(--kanagawa-bg-dark) !important;
      color: var(--kanagawa-fg) !important;
      border-color: var(--kanagawa-gray) !important;
    }
    
    /* Bookmarks Bar */
    #PersonalToolbar .bookmark-item {
      color: var(--kanagawa-fg) !important;
      background-color: transparent !important;
    }
    
    #PersonalToolbar .bookmark-item:hover {
      background-color: var(--kanagawa-bg-light) !important;
      border-radius: 4px !important;
    }
    
    /* Scrollbars */
    scrollbar {
      background-color: var(--kanagawa-bg) !important;
    }
    
    scrollbar thumb {
      background-color: var(--kanagawa-gray) !important;
      border-radius: 4px !important;
    }
    
    scrollbar thumb:hover {
      background-color: var(--kanagawa-blue) !important;
    }
  '';
  
  # Custom CSS for webpage content (dark mode)
  home.file.".zen/chrome/userContent.css".text = ''
    /* Dark mode for websites that don't have it */
    @-moz-document url-prefix(http://), url-prefix(https://), url-prefix(file://) {
      :root {
        color-scheme: dark !important;
      }
    }
    
    /* Custom scrollbars for web content */
    * {
      scrollbar-width: thin !important;
      scrollbar-color: #54546d #1f1f28 !important;
    }
  '';
  
  # Set Zen as default browser
  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen.desktop";
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
  };
  
  # Create desktop entry for Zen browser
  xdg.desktopEntries.zen = {
    name = "Zen Browser";
    comment = "A Firefox-based browser focused on privacy";
    exec = "zen %U";
    icon = "zen";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ 
      "text/html" 
      "text/xml" 
      "application/xhtml+xml" 
      "x-scheme-handler/http" 
      "x-scheme-handler/https" 
    ];
    startupNotify = true;
  };
}
