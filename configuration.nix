# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;
  networking.wireless.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
  
  services.xserver = {
    enable = true;
    layout = "us";
    windowManager.i3.enable = true;
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    videoDrivers = ["intel"];
  };
  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:2:0:0";
  };
  hardware.bumblebee.enable = true;
  # Configure keymap in X11
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

	 services.picom = {
	  enable = true;
	  vSync = true;
	}; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kirill = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };
  
  programs.fish.enable = true;
  users.users.kirill = {
    shell = pkgs.fish;
  }; 

  programs.steam.enable = true;
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/var/spool/nginx/logs/" ];
  services.nginx.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    networkmanager
    pciutils
    wpa_supplicant
    dmenu
    kate
    glxinfo
    tree
    wget
    # terminals
    st
    alacritty 
    
    # programming
    nodejs
    python3
    python38Packages.pip
    python27
    clang
    clang-tools
    docker
    docker-compose
    astyle
    gcc
    gnumake
    cmake
    binutils-unwrapped
    zlib
    cargo
    rustup
    rls
    nginx


    # additional programs
    zoom-us
    tdesktop
    discord
    flameshot
    jetbrains.pycharm-professional
    steam
    postman
    (steam.override { withPrimus = true; extraPkgs = pkgs: [ bumblebee glxinfo]; nativeOnly = true; }).run
    libreoffice-fresh
    hunspellDicts.ru_RU

    vim
    neovim
    firefox
    chromium
    xfce.thunar
    wine
    unzip

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "20.09"; # Did you read the comment?

}

