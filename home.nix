{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "mjmaurer";
  home.homeDirectory = "/home/mjmaurer";

  home.packages = with pkgs; [
    ripgrep
    bat
    htop
    wget
    neofetch
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    initExtra = builtins.readFile ./programs/bash/bashrc;
    profileExtra = builtins.readFile ./programs/bash/profile;
    shellAliases = {
      ".."  = "cd ..";
      "gc" = "git commit -v";
      "ga" = "git add --all";
      "gs"  = "git status";
      "hig"  = "bat ~/.bash_history | grep";
      "la"  = "ls -A --color";
      "ls"  = "ls --color";
    };
  };

  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Michael Maurer";
    userEmail = "mjmaurer777@gmail.com";
    aliases = {
      pr = "pull --rebase";
    };
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./programs/vim/config.vim;
    plugins = with pkgs.vimPlugins; [
      vim-polyglot
    ];
  };
}
