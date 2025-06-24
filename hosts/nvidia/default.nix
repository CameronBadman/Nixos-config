{
  services.xserver = {
    videoDrivers = ["nvidia"];
    xkb.options = "ctrl:swapcaps";
  };
}
