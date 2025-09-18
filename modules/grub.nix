{...}: {
  boot = {
    supportedFilesystems = ["ntfs"];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        useOSProber = true;
        timeoutStyle = "menu";
        default = "saved";
        configurationLimit = 5;

        minegrub-theme = {
          enable = true;
          splash = "May contain penguins!";
          background = "background_options/1.20 - [Trails & Tales].png";
        # "background_options/1.15 - [Buzzy Bees].png"
        # "background_options/1.21.5 - [Spring to Life].png"
        # "background_options/1.8 - [Classic Minecraft].png"
          boot-options-count = 5;
        };

        #minegrub-world-sel = {
        #  enable = true;
        #  customIcons = [
        #    {
        #      name = "nixos";
        #      lineTop = "NixOS (23/11/2023, 23:03)";
        #      lineBottom = "Survival Mode, No Cheats, Version: 23.11";
        #      imgName = "nixos";
        #    }
        #  ];
        #};

      };
      timeout = 20;
    };
  };
}
