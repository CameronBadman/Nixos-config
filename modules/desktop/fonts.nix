{ config, lib, pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # Move fontconfig inside the fonts configuration
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- Use medium weight for better readability -->
          <match target="pattern">
            <test qual="any" name="family">
              <string>JetBrainsMono Nerd Font Mono</string>
            </test>
            <edit name="weight" mode="assign">
              <const>medium</const>
            </edit>
          </match>
          
          <!-- Enable light hinting -->
          <match target="pattern">
            <edit name="hintstyle" mode="assign">
              <const>hintslight</const>
            </edit>
          </match>
          <!-- Enable antialiasing -->
          <match target="pattern">
            <edit name="antialias" mode="assign">
              <bool>true</bool>
            </edit>
          </match>
          <!-- Set LCD filter -->
          <match target="pattern">
            <edit name="lcdfilter" mode="assign">
              <const>lcddefault</const>
            </edit>
          </match>
          <!-- Disable bitmap fonts -->
          <selectfont>
            <rejectfont>
              <pattern>
                <patelt name="scalable"><bool>false</bool></patelt>
              </pattern>
            </rejectfont>
          </selectfont>
        </fontconfig>
      '';
    };
  };
}

