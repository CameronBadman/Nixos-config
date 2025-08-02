{ config, lib, pkgs, ... }: {
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = false;  # Fixed: can't use fine-grained with sync mode
    
    prime = {
      sync.enable = true;      # Required for USB-C DisplayPort
      offload.enable = false;  # This mode breaks USB-C displays
      amdgpuBusId = "PCI:4:0:0";  # Matches your AMD GPU
      nvidiaBusId = "PCI:1:0:0";  # Matches your NVIDIA GPU
    };
  };

  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "amdgpu.dcdebugmask=0x10"
    "processor.max_cstate=1"
  ];

  boot.initrd.kernelModules = [
    "amdgpu" "nvidia" "nvidia-drm" "nvidia-modeset"
  ];

  # Modern graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For 32-bit applications
  };

  # Performance environment variables
  environment.variables = {
    __GL_VRR_ALLOWED = "1";
    __GL_MaxFramesAllowed = "1";
    __NV_PRIME_RENDER_OFFLOAD = "0";
  };

  services.asusd.enable = true;
  services.supergfxd.enable = true;
}
