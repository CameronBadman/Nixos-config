{ config, lib, pkgs, ... }: {
  imports = [ ./core ./desktop ./hardware ./programs ];
}
