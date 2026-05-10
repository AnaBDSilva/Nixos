# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.anabs = import ./home.nix;

  fileSystems = {
    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "ext4";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  boot.kernelPackages = pkgs.linuxPackages_zen;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.flatpak.enable = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anabs = {
    isNormalUser = true;
    description = "Ana Silva";
    extraGroups = ["networkmanager" "wheel" "docker" "ubridge" "kvm" "libvirtd" "wireshark"];
    shell = pkgs.zsh;
  };

  environment.sessionVariables = {
    NH_FLAKE = "$HOME/Nixos";
  };

  #DEFINE ALIAS HERE --- !
  environment.shellAliases = {
    l = null;
    ll = "ls -l";
    getToWork = "cd /home/anabs/Documents/Uni/2ºSemestre/";
    getToProject = "cd /home/anabs/Documents/Uni/2ºSemestre/project/pyDHM-master/";
    getToJavaTraining = "cd /home/anabs/Documents/Uni/2ºSemestre/SD/my-app/src/main/java/com/sistemasDistribuidos/";
    #hello = "echo 'Ola o meu nome e $nome, e sou natural de $naturalidade.'";
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
  nixpkgs.config.cudaSupport = true;

  programs.coolercontrol = {
    enable = true;
  };

  programs.gnupg.agent.enable = true;
  programs.steam.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #for python thing
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
    libGL
    libX11
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    vscode
    vesktop
    git
    nixd
    alejandra
    nh
    #lutris
    #netbeans
    #scenebuilder
    wine
    winetricks
    protonup-qt
    gitkraken
    android-studio
    prismlauncher
    lm_sensors
    wpsoffice
    karere
    heroic
    rhythmbox
    gummy
    mongodb-compass
    openssl
    #eclipses.eclipse-java
    pavucontrol
    mlocate
    open-vm-tools
    todoist-electron
    (pkgs.lutris.override {
      # Intercept buildFHSEnv to modify target packages
      buildFHSEnv = args:
        pkgs.buildFHSEnv (args
          // {
            multiPkgs = envPkgs: let
              # Fetch original package list
              originalPkgs = args.multiPkgs envPkgs;

              # Disable tests for openldap
              customLdap = envPkgs.openldap.overrideAttrs (_: {doCheck = false;});
            in
              # Replace broken openldap with the custom one
              builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [customLdap];
          });
    })
    
  ];

  services.thermald.enable = true;
  virtualisation.docker = {
    enable = true;
  };

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.extraOptions = ''accept-flake-config = true'';
  nix.settings = {
    download-buffer-size = 134217728;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 30d";
    flake = "$HOME/Nixos";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
