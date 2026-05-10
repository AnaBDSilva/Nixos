{ config, pkgs, ...}:
{
  home = {
    username = "anabs";
    homeDirectory = "/home/anabs";
    stateVersion = "25.05";
  };

  programs = {
    firefox.enable = true;
  };
}