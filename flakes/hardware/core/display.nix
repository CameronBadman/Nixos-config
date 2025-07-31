{ config, lib, pkgs, ... }: {
  hardware.nvidia = {
    open = false;  # Stick with proprietary for GTX 2060 Max-Q
    
    # Performance-focused power management
    powerManagement.enable = false;  # Don't need battery optimization
    
    # Use the stable driver branch
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Force NVIDIA as primary (no switching needed)
    prime = {
      sync.enable = true;  # Always use NVIDIA, better performance
      # Still need bus IDs - get with: lspci | grep -E "VGA|3D"
      intelBusId = "PCI:0:2:0";    # Replace with actual
      nvidiaBusId = "PCI:1:0:0";   # Replace with actual
    };
    
    # Performance optimizations
    forceFullCompositionPipeline = true;
    modesetting.enable = true;
  };

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
}
