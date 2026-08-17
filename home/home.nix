{ config, inputs, pkgs, freesmlauncher, ... }:

{
  home.username = "xir";
  home.homeDirectory = "/home/xir";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  programs.vim.enable = true;

  home.packages = with pkgs; [ 
    docker
    docker-compose
    qbittorrent 
    opencode-desktop
    telegram-desktop
    prismlauncher
    lazygit
    inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher
  ];

  services.syncthing = {
    enable = true;
  };

  programs.git = {
    enable = true;

    includes = [
      { path = "~/.config/git/config.local"; }
    ];
  };

  home.sessionVariables = {
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
    NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";

    CARGO_HOME = "${config.xdg.dataHome}/cargo";

    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";

    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "--login" ];
      };
    };
  };

  programs.zsh = {
   enable = true;

   dotDir = "${config.xdg.configHome}/zsh";
   
   enableCompletion = true;
   autosuggestion.enable = true;
   syntaxHighlighting.enable = true;

   history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
   };

   shellAliases = {
     ll = "ls -l";
     update = "sudo nixos-rebuild switch";
     v = "vim";
     g = "git";
     lg = "lazygit";
     tldr = "tldr --short-options";
   };

   oh-my-zsh = {
     enable = true;
     plugins = [ "git" "docker" "docker-compose" ];
     theme = "robbyrussell";
   };
 };

 programs.tmux = {
    enable = true;

    shell = "${pkgs.zsh}/bin/zsh";

    shortcut = "q";
    mouse = true;
    keyMode = "vi";
    historyLimit = 50000;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      # Environment and Clipboard
      set -g set-clipboard on
      set -s copy-command 'xclip -in -selection clipboard'

      # Interface and Layout
      set-option -g status-position top

      # Navigation Keybindings
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Vi Copy-Mode Keybindings
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi V send -X select-line
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # Config Reload Binding
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
    '';
  };
}
