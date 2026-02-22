{ config, pkgs,pkgs-unstable, lib, modulesPath, ... }:
let 
  user = "mtkclient";
in
{

  networking.hostName = "nixos-mtk"; 

  # Enable networking
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  
  # ISO overrides
  image.modules.iso = {
    isoImage = {
      squashfsCompression = "zstd -Xcompression-level 6";
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
        xfce.enable = true;
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
    #ristretto
    #xfce4-appfinder
    #xfce4-notifyd
    #xfce4-screenshooter
   # xfce4-session
   # xfce4-settings
   # xfce4-taskmanager
   # xfce4-terminal 
  ];


  # Keymap 
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users."${user}" = {
    isNormalUser = true;
    description = "mtkclient";
    extraGroups = [ "networkmanager" "wheel" ];
    password = "1234";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = 
    (with pkgs; [
      neovim 
      librewolf
    ])

    ++

    (with pkgs-unstable; [
      mtkclient
    ]);

  programs.adb.enable = true;

  home-manager.users.mtkclient = { ... }: 
    let
      wp = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
      background-dir  = "/home/${user}/.xfce4-wallpapers";
      background-image = "${background-dir}/nineish-dark-gray.png";
    in {
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

    home.file = {
      ".xfce4-wallpapers/nineish-dark-gray.png".source = wp;
    };

    xfconf = { 
      enable = true;
      settings = {
        xfce4-desktop = {
          "desktop-icons/file-icons/show-trash"      = true;
          "desktop-icons/file-icons/show-home"       = false;
          "desktop-icons/file-icons/show-filesystem" = false;
          
          "backdrop/screen0/monitor0/workspace0/color-style" = 0;
          "backdrop/screen0/monitor0/workspace0/image-style" = 5;
          "backdrop/screen0/monitor0/workspace0/last-image" = background-image;
          "backdrop/screen0/monitor0/workspace1/color-style" = 0;
          "backdrop/screen0/monitor0/workspace1/image-style" = 5;
          "backdrop/screen0/monitor0/workspace1/last-image" = background-image;
          "backdrop/screen0/monitorDP-1/workspace0/color-style" = 0;
          "backdrop/screen0/monitorDP-1/workspace0/image-style" = 5;
          "backdrop/screen0/monitorDP-1/workspace0/last-image" = background-image;
          "backdrop/screen0/monitorDP-1/workspace1/color-style" = 0;
          "backdrop/screen0/monitorDP-1/workspace1/image-style" = 5;
          "backdrop/screen0/monitorDP-1/workspace1/last-image" = background-image;
          "backdrop/screen0/monitorDP-2/workspace0/color-style" = 0;
          "backdrop/screen0/monitorDP-2/workspace0/image-style" = 5;
          "backdrop/screen0/monitorDP-2/workspace0/last-image" = background-image;
          "backdrop/screen0/monitorDP-2/workspace1/color-style" = 0;
          "backdrop/screen0/monitorDP-2/workspace1/image-style" = 5;
          "backdrop/screen0/monitorDP-2/workspace1/last-image" = background-image;

        };
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; 

}
