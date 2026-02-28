{ config, pkgs,pkgs-unstable, lib, modulesPath, ... }:
let 
  user = "mtkclient";
in
{

  networking.hostName = "nixos-mtk"; 

  # Enable networking
  networking.networkmanager.enable = true;

  # Hardware
  hardware = {
    enableAllHardware = true; 
    enableRedistributableFirmware = true;
  };

  # ISO overrides
  image.modules.iso = {
    isoImage = {
      #squashfsCompression = "zstd -Xcompression-level 6";
      # Smaller build, longer build time.
      squashfsCompression = "xz -Xdict-size 100% -b 1M"; 
      makeEfiBootable = lib.mkForce true;
    };
    # faster
    #isoImage.squashfsCompression = "zstd -Xcompression-level 3";
    # fastest
    #isoImage.squashfsCompression = "lz4";
  };

  boot.loader.timeout = lib.mkForce 0;

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

  #Auto-mounting USB/MTP for Android
  services.gvfs.enable = true;
  
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

  home-manager.users.mtkclient = { config, pkgs, lib, ... }: 
    let
      desktop-dir = config.xdg.userDirs.desktop;
      desktop-rel = lib.strings.removePrefix (config.home.homeDirectory + "/") desktop-dir;
    in {

    home = {
      username = user;
      homeDirectory = "/home/${user}";
      stateVersion = "25.11";
      file = {
        "Desktop/Garaho Wiki.desktop" = {
          executable = true;
          text = ''
            [Desktop Entry]
            Type=Application
            Name=Garaho Wiki
            Exec=librewolf https://garahowiki.com/
            Icon=applications-internet
            Terminal=false
          '';
          };
      
        # Browser
        ".config/xfce4/panel/launcher-13/browser.desktop" = {
          executable = true;
          text = ''
            [Desktop Entry]
            Type=Application
            Name=Web
            Exec=librewolf
            Icon=web-browser
            Terminal=false
          '';
          };

        # File Manager
        ".config/xfce4/panel/launcher-14/files.desktop" = {
          executable = true;
          text = ''
            [Desktop Entry]
            Type=Application
            Name=Files
            Exec=thunar
            Icon=system-file-manager
            Terminal=false
          '';
          };

          # Terminal
        ".config/xfce4/panel/launcher-15/terminal.desktop" = {
          executable = true;
          text = ''
            [Desktop Entry]
            Type=Application
            Name=Terminal
            Exec=xfce4-terminal
            Icon=utilities-terminal
            Terminal=false
          '';
          };
      
      
        ".config/xfce4/panel/launcher-16/xfce4-appfinder.desktop" = {
          executable = true;
          text = ''
            [Desktop Entry]
            Version=1.0
            Type=Application
            Name=Application Finder
            Comment=Find and launch applications
            Exec=xfce4-appfinder
            Icon=org.xfce.appfinder
            Terminal=false
            Categories=Utility;X-XFCE;
            StartupNotify=true
          '';
          };
    };

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
        xfce4-panel = {
          
          "configver" = 2;

          "panels" = [ 1 2 ];

          # Dark-mode
          "panels/dark-mode" = true;

          # Panel 1
          "panels/panel-1/icon-size" = 16;
          "panels/panel-1/length" = 100;
          "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 19 ];
          "panels/panel-1/position" = "p=6;x=0;y=0";
          "panels/panel-1/position-locked" = true;
          "panels/panel-1/size" = 26;
          
          # Panel 2
          "panels/panel-2/autohide-behavior" = 1;
          "panels/panel-2/length" = 1;
          "panels/panel-2/plugin-ids" = [ 11 12 13 14 15 16 17 18 ];
          "panels/panel-2/position" = "p=10;x=0;y=0";
          "panels/panel-2/position-locked" = true;
          "panels/panel-2/size" = 48;

          # Panel 1 Plugins
          "plugins/plugin-1" = "applicationsmenu";

          "plugins/plugin-2" = "tasklist";
          "plugins/plugin-2/grouping" = 1;

          "plugins/plugin-3" = "separator";
          "plugins/plugin-3/expand" = true;
          "plugins/plugin-3/style" = 0;

          "plugins/plugin-4" = "pager";

          "plugins/plugin-5" = "separator";
          "plugins/plugin-5/style" = 0;

          "plugins/plugin-6" = "systray";

          "plugins/plugin-6/known-legacy-items" = [
            "ethernet network connection \"wired connection 1\" active"
          ];
          "plugins/plugin-6/square-icons" = true;

          "plugins/plugin-7" = "separator";
          "plugins/plugin-7/style" = 0;

          "plugins/plugin-8" = "clock";

          "plugins/plugin-9" = "separator";
          "plugins/plugin-9/style" = 0;

          "plugins/plugin-10" = "actions";
          "plugins/plugin-10/appearance" = 0;
          "plugins/plugin-10/items" = [
            "-lock-screen"
            "-switch-user"
            "+separator"
            "+suspend"
            "-hibernate"
            "-hybrid-sleep"
            "-separator"
            "+restart"
            "+shutdown"
            "+separator"
            "-logout"
            "-logout-dialog"
          ];

          # Panel 2 Config
          "plugins/plugin-11" = "showdesktop";

          "plugins/plugin-12" = "separator";

          "plugins/plugin-13" = "launcher";
          "plugins/plugin-13/items" = [ "browser.desktop" ];

          "plugins/plugin-14" = "launcher";
          "plugins/plugin-14/items" = [ "files.desktop" ];

          "plugins/plugin-15" = "launcher";
          "plugins/plugin-15/items" = [ "terminal.desktop" ];

          "plugins/plugin-16" = "launcher";
          "plugins/plugin-16/items" = [ "xfce4-appfinder.desktop" ];

          "plugins/plugin-17" = "separator";

          "plugins/plugin-18" = "directorymenu";
          "plugins/plugin-18/base-directory" = "/home/${user}";
          
          "plugins/plugin-19" = "power-manager-plugin";

        };
      };
    };
  };

  # Remove printing services
  services.system-config-printer.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; 

}
