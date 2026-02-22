{ config, pkgs,pkgs-unstable, lib, modulesPath, ... }:
let 
  user = "mtkclient";
in
{

  networking.hostName = "nixos-mtk"; 

  # Enable networking
  networking.networkmanager.enable = true;
  
  # ISO overrides
  image.modules.iso = {
    isoImage = {
      squashfsCompression = "zstd -Xcompression-level 6";
      # Smaller build, longer build time.
      #squashfsCompression = "xz -Xdict-size 100% -b 1M"; 
      makeEfiBootable = lib.mkForce true;
    };
    # faster
    #isoImage.squashfsCompression = "zstd -Xcompression-level 3";
    # fastest
    #isoImage.squashfsCompression = "lz4";
  };

  boot.loader.timeout = lib.mkForce 1;

  # xfce
  services = {
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce = { 
          enable = true;
          enableScreensaver = false;
        };
      };
    };
    displayManager.autoLogin = {
      enable = true;
      user = user;
    };
  };
  
  # Excluded xfce packages
  environment.xfce.excludePackages = with pkgs.xfce; [
    #mousepad
    parole
    ristretto
    #xfce4-appfinder
    #xfce4-notifyd
    xfce4-screenshooter
    #xfce4-session
   # xfce4-settings
   # xfce4-taskmanager
   # xfce4-terminal 
  ];

  # User
  users.users."${user}" = {
    isNormalUser = true;
    description = "mtkclient";
    extraGroups = [ "networkmanager" "wheel" ];
    password = "1234";
  };

  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = 
    (with pkgs; [
      librewolf
    ])
    ++
    (with pkgs-unstable; [
      mtkclient
    ]);

  programs.adb.enable = true;

  home-manager.users.mtkclient = { ... }: 
    {
    xdg = {
      configFile."xfce4/helpers.rc".text = ''
      WebBrowser=librewolf
    '';
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html"             = [ "librewolf.desktop" ];
          "x-scheme-handler/http" = [ "librewolf.desktop" ];
          "x-scheme-handler/https"= [ "librewolf.desktop" ];
        };
      };
      dataFile."xfce4/helpers/librewolf.desktop".text = ''
      [Desktop Entry]
      Type=X-XFCE-Helper
      Name=LibreWolf
      Icon=librewolf
      X-XFCE-Category=WebBrowser
      X-XFCE-Commands=librewolf
      X-XFCE-CommandsWithParameter=librewolf "%s"
    '';

    };

    xfconf = { 
      enable = true;
      settings = {
        xfce4-desktop = {
          "desktop-icons/file-icons/show-trash"      = true;
          "desktop-icons/file-icons/show-home"       = false;
          "desktop-icons/file-icons/show-filesystem" = false;
        };
      };
    };
  };

  services.system-config-printer.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; 

}
