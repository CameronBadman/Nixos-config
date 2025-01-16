{
  networking = {
    wireless = {
      enable = true;
      
      # Specify all known networks
      networks = {
        # Home Network
        "" = {
          psk = "";
        };

        # Work Network
        #"WorkWiFi" = {
        #  psk = "WorkPassword456";
                # };

        };

    };
  };
}

