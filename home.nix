{ config, pkgs, ... }:

{
  home.username = "ez";
  home.homeDirectory = "/home/ez";
  home.stateVersion = "24.05";

  # Packages to install
  home.packages = with pkgs; [
    nodejs
    git
    vim
    curl
    wget
    ripgrep
    fd
    fzf
    jq
    lazygit
    zoxide
    # Add more packages here as needed
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Programs to configure
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      # Custom aliases
      alias ll='ls -la'
      alias la='ls -A'
      alias l='ls -CF'
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit'
      alias gp='git push'
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    # Note: set your name/email separately with:
    # git config --global user.name "Your Name"
    # git config --global user.email "your@email.com"
  };

  # Let home-manager handle some basic configs
  programs.home-manager.enable = true;
}
