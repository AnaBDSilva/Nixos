{config, pkgs, ...}: {

hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable =  false;
      powerManagement.finegrained = true;
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.beta;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        offload.enable = true;
        offload.enableOffloadCmd = true;
      };
    };
    graphics = {
      enable = true;
       extraPackages = [
        pkgs.vulkan-loader
        pkgs.vulkan-validation-layers
        pkgs.vulkan-extension-layer
        pkgs.libGL
      ];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

}

