# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# Much inspiration from here: 
#
#    https://github.com/chaoflow/nixos-configurations/blob/master/configuration-eve.nix
#
# Se options here
#
#  https://nixos.org/nixos/manual/options.html
#
# OO<Enter> to open this file

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot = {
    extraModprobeConfig =
      ''
        options thinkpad_acpi fan_control=1
      '';
    loader = {
      gummiboot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "msr" ]; # for powertop
    kernelPackages = pkgs.linuxPackages_3_18;
  };

  networking = {
    hostName = "ship"; # Define your hostname.
    # networkmanager.enable = true;
    enableIPv6 = false;
    wireless = {
      enable = false;
      driver = "nl80211,wext";
      interfaces = [ "wlp3s0" ];
    };
    supplicant = {
      wlp3s0 = {
         userControlled = {
           group = "network";
        };
        configFile = {
          path = "/etc/wpa_supplicant.conf";
        };
      };
    };
    extraHosts = ''
      192.168.1.145 station
      192.168.1.213 ship
    '';

    firewall = {
      enable = false;
      allowedTCPPorts = [ 80 ];
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  hardware = {
    pulseaudio = {
      enable = true;
    };
    trackpoint = {
      enable = true;
      # fakeButtons = true;
      sensitivity = 128;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;

    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };

    chromium = {
      enablePepperFlash = true; # Chromium removed support for Mozilla (NPAPI) plugins so Adobe Flash no longer works
      enablePepperPDF = true;
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    a2ps
    abiword
    abook
    abook
    acpi
    acpid
    acpitool
    ag
    alsaLib
    alsaPlugins
    alsaUtils
    ant
    antiword
    asciidoc
    aspell
    autoconf
    bash
    bashCompletion
    bashInteractive
    bc
    calc
    cdecl
    chromium
    clipgrab
    clojure
    closurecompiler
    cmake
    conky
    cpufrequtils
    ctags
    curl
    ddrescue
    debootstrap
    di
    dict
    docker
    drumgizmo
    drumkv1
    dzen2
    elinks
    evince
    fakechroot
    fakeroot
    file
    firefox
    flac
    gcc
    gdb
    geany
    geeqie
    ghostscript
    gimp
    git
    gitAndTools.git-extras
    gitg
    giv
    glxinfo
    gnumake
    gnumeric
    gnupg
    gperf
    graphicsmagick
    graphviz
    groff
    gtk2
    guile
    gv
    hdparm
    herbstluftwm
    htop
    i2c-tools
    idutils
    ikiwiki
    imagemagick
    imagemagick
    imgurbash
    inkscape
    inotify-tools
    intel-gpu-tools
    irssi
    iw
    jack2Full
    jscoverage
    lessc
    libinput
    linuxPackages.virtualbox
    lm_sensors
    lm_sensors
    lua
    lynx
    lyx
    man
    mdbtools
    meld
    multitail
    mutt
    ncdu
    ncftp
    ncurses
    netcat
    newsbeuter
    nginx
    ngrep
    nixpkgs-lint
    nox
    octave
    openjdk
    opera
    optipng
    p7zip
    pandoc
    parallel
    perl
    pgadmin
    pinentry
    pkgconfig
    pkgs.gtk2
    plantuml
    plantuml
    pngcrush
    pngtoico
    postgresql
    powertop
    processing
    procps
    pstree
    python
    python27Packages.curses
    python27Packages.pip
    python3
    qjackctl
    qpdf
    qpdfview
    qt55.qtsvg
    redis
    ruby
    rubygems
    rustc
    rustfmt
    rxvt_unicode-with-plugins
    sassc
    scribus
    sdparm
    slim
    sloc
    sox
    sshfsFuse
    stdmanpages
    suidChroot
    surf
    tcpdump
    thinkfan
    tig
    tmux
    tmuxinator
    tree
    umlet
    unison
    unrar
    unzip
    upower
    urlview
    uzbl
    vifm
    vim_configurable
    vlc
    wget
    which
    wpa_supplicant_gui
    xclip
    xdg_utils
    xlaunch
    xorg.xev
    xorg.xf86videointel
    xorg.xinput
    xorg.xmessage
    xorg.xmodmap
    xpdf
    xsensors
    zeal
    zip
  ];

  nixpkgs.config.packageOverrides = pkgs : rec {
    gnupg = pkgs.gnupg21;
  };

  programs = {
    bash = {
      enableCompletion = true;
    };
  };

  # List services that you want to enable:

  services = {
    udev.extraRules = ''
      ACTION="add", SUBSYSTEM="net", ATTR{ADDRESS}=="28:b2:bd:0c:b4:c6", NAME="wlan0" 
    '';
  };

  services.thinkfan = {
    enable = true;
    sensor = "/sys/class/hwmon/hwmon0/temp1_input";
  };

  services.openssh.enable = false;


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  virtualisation.docker.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    enableTCP = false;
    exportConfiguration = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    multitouch = {
      enable = true;
      # ignorePalm = true;
      tapButtons = true;
    };
    synaptics = {
      enable = true;
      twoFingerScroll = true;
      vertTwoFingerScroll = true;
      horizTwoFingerScroll = true;
      tapButtons = true;
      horizontalScroll = true;
##        additionalOptions = ''
##         Driver "synaptics"
##         MatchIsTouchpad "on"
##         MatchDevicePath "/dev/input/event*"
##         Option  "Parameter"     ""
##         Option  "LeftEdge"      "51"
##         Option  "RightEdge"     "1229"
##         Option  "TopEdge"       "36"
##         Option  "BottomEdge"    "644"
##         Option  "FingerLow"     "5"
##         Option  "FingerHigh"    "5"
##         Option  "MaxTapTime"    "100"
##         Option  "MaxTapMove"    "100"
##         Option  "MaxDoubleTapTime"      "180"
##         Option  "SingleTapTimeout"      "180"
##         Option  "ClickTime"     "100"
##         Option  "EmulateMidButtonTime"  "0"
##         Option  "EmulateTwoFingerMinZ"  "1000"
##         Option  "EmulateTwoFingerMinW"  "15"
##         Option  "VertScrollDelta"       "28"
##         Option  "HorizScrollDelta"      "28"
##         Option  "VertEdgeScroll"        "0"
##         Option  "HorizEdgeScroll"       "0"
##         Option  "CornerCoasting"        "0"
##         Option  "VertTwoFingerScroll"   "1"
##         Option  "HorizTwoFingerScroll"  "1"
##         Option  "MinSpeed"      "1"
##         Option  "MaxSpeed"      "1.75"
##         Option  "AccelFactor"   "0.138026"
##         Option  "TouchpadOff"   "0"
##         Option  "LockedDrags"   "0"
##         Option  "LockedDragTimeout"     "5000"
##         Option  "RTCornerButton"        "0"
##         Option  "RBCornerButton"        "0"
##         Option  "LTCornerButton"        "0"
##         Option  "LBCornerButton"        "0"
##         Option  "TapButton1"    "1"
##         Option  "TapButton2"    "2"
##         Option  "TapButton3"    "3"
##         Option  "ClickFinger1"  "1"
##         Option  "ClickFinger2"  "3"
##         Option  "ClickFinger3"  "2"
##         Option  "CircularScrolling"     "0"
##         Option  "CircScrollDelta"       "0.1"
##         Option  "CircScrollTrigger"     "0"
##         Option  "PalmDetect"    "0"
##         Option  "PalmMinWidth"  "10"
##         Option  "PalmMinZ"      "200"
##         Option  "CoastingSpeed" "255"
##         Option  "CoastingFriction"      "5"
##         Option  "PressureMotionMinZ"    "30"
##         Option  "PressureMotionMaxZ"    "160"
##         Option  "PressureMotionMinFactor"       "1"
##         Option  "PressureMotionMaxFactor"       "1"
##         Option  "ResolutionDetect"      "1"
##         Option  "GrabEventDevice"       "1"
##         Option  "TapAndDragGesture"     "1"
##         Option  "AreaLeftEdge"  "0"
##         Option  "AreaRightEdge" "0"
##         Option  "AreaTopEdge"   "0"
##         Option  "AreaBottomEdge"        "0"
##         Option  "HorizHysteresis"       "7"
##         Option  "VertHysteresis"        "7"
##         Option  "ClickPad"      "1"
##         Option  "RightButtonAreaLeft"   "0"
##         Option  "RightButtonAreaRight"  "0"
##         Option  "RightButtonAreaTop"    "0"
##         Option  "RightButtonAreaBottom" "0"
##         Option  "MiddleButtonAreaLeft"  "0"
##         Option  "MiddleButtonAreaRight" "0"
##         Option  "MiddleButtonAreaTop"   "0"
##         Option  "MiddleButtonAreaBottom"        "0"
##        '';
    };
    windowManager = {
      herbstluftwm.enable = true;
    };
  }; 

  services.postgresql = {
    enable = false;
    package = pkgs.postgresql95;
    authentication = "local all all ident";
  };

  services.locate.enable = true;

  services.gpm = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers = {
    alt = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "users" "wheel" "networkmanager" "pulseaudio" "audio" "video" "power" "docker" ];
    };
    homedir = {
      isNormalUser = true;
      uid = 1001;
      extraGroups = [ "users" "networkmanager" "pulseaudio" "audio" "video" "power" "docker" ];
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}

# vi: ft=conf,sw=2,expandtabs
