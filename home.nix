{ config, pkgs, herdrPkg, ... }:
let
  dotfiles = config.home.homeDirectory + "/.dotfiles";
in
{
  home.username = "ez";
  home.homeDirectory = "/home/ez";
  home.stateVersion = "24.05";

  # Packages to install
  home.packages = with pkgs; [
    nodejs
    git
    vim
    neovim
    emacs
    curl
    wget
    ripgrep
    fd
    fzf
    jq
    lazygit
    zoxide
    gemini-cli
    opencode
    tuicr
    herdrPkg
    nixd # Nix language server, used by Neovim (home/.config/nvim)
    tree-sitter # CLI needed by nvim-treesitter to build some parsers (e.g. typescript, tsx)
    # Add more packages here as needed
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    AGENT_NOTES_DIR = "$HOME/vaults/agent-notes";
  };

  # Extra directories to prepend to PATH
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  # Programs to configure
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      append = true;
    };
    # Reload session variables in every new shell, so home.nix changes apply
    # to new terminals without logging out. typeset -U keeps PATH free of duplicates.
    envExtra = ''
      typeset -U path PATH
      unset __HM_SESS_VARS_SOURCED
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
    '';
    initContent = ''
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Ervis Zyka";
      user.email = "erviszyka@gmail.com";
    };
  };

  # Let home-manager handle some basic configs
  programs.home-manager.enable = true;

  # Symlink config files to dotfiles repo (editable in place)
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/tuicr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/tuicr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  # Local dictation script, see dictation/README.md
  home.file.".local/bin/dictate-toggle".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.local/bin/dictate-toggle";
}
