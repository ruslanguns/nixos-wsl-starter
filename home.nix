{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    jq
    killall
    mosh
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
  ];

  stable-packages = with pkgs; [
    # key tools
    gh # for bootstrapping
    just

    # core languages
    rustup

    # rust stuff
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    nil # nix

    # formatters and linters
    alejandra # nix
    deadnix # nix
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    starship.enable = true;
    starship.settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      python.disabled = true;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
    };

    fzf.enable = true;
    fzf.enableFishIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;
    zoxide.options = ["--cmd cd"];
    broot.enable = true;
    broot.enableFishIntegration = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    # git = {
    #   enable = true;
    #   package = pkgs.unstable.git;
    #   delta.enable = true;
    #   delta.options = {
    #     line-numbers = true;
    #     side-by-side = true;
    #     navigate = true;
    #   };
    #   userEmail = "ruslanguns@gmail.com"; # FIXME: set your git email
    #   userName = "Ruslan Gonzalez"; #FIXME: set your git username
    #   extraConfig = {
    #     push = {
    #       default = "current";
    #       autoSetupRemote = true;
    #     };
    #     merge = {
    #       conflictstyle = "diff3";
    #     };
    #     diff = {
    #       colorMoved = "default";
    #     };
    #   };
    # };

    fish = {
      enable = false;
      # FIXME: run 'scoop install win32yank' on Windows, then add this line with your Windows username to the bottom of interactiveShellInit
      # fish_add_path --append /mnt/c/Users/<Your Windows Username>/scoop/apps/win32yank/0.1.1
      # interactiveShellInit = ''
      #   ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      #   ${pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
      #       owner = "rebelot";
      #       repo = "kanagawa.nvim";
      #       rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
      #       sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
      #     }
      #     + "/extras/kanagawa.fish")}

      #   set -l code_path (find ~/.vscode-server/bin -name "code" -type f | head -n 1)
      #   if test -n "$code_path"
      #     set -gx PATH (dirname $code_path) $PATH
      #   end

      #   set -U fish_greeting
      # '';
      # functions = {
        refresh = "source $HOME/.config/fish/config.fish";
        take = ''mkdir -p -- "$1" && cd -- "$1"'';
        ttake = "cd $(mktemp -d)";
        show_path = "echo $PATH | tr ' ' '\n'";
        posix-source = ''
          for i in (cat $argv)
            set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
          end
        '';
      };
      # shellAbbrs =
      #   {
      #     gc = "nix-collect-garbage --delete-old";
      #   }
      #   # navigation shortcuts
      #   // {
      #     ".." = "cd ..";
      #     "..." = "cd ../../";
      #     "...." = "cd ../../../";
      #     "....." = "cd ../../../../";
      #   }
      #   # git shortcuts
      #   // {
      #     gapa = "git add --patch";
      #     grpa = "git reset --patch";
      #     gst = "git status";
      #     gdh = "git diff HEAD";
      #     gp = "git push";
      #     gph = "git push -u origin HEAD";
      #     gco = "git checkout";
      #     gcob = "git checkout -b";
      #     gcm = "git checkout master";
      #     gcd = "git checkout develop";
      #     gsp = "git stash push -m";
      #     gsa = "git stash apply stash^{/";
      #     gsl = "git stash list";
      #   };
      # shellAliases = {
      #   pbcopy = "/mnt/c/Windows/System32/clip.exe";
      #   pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
      #   explorer = "/mnt/c/Windows/explorer.exe";
      # };
      # plugins = [
      #   {
      #     inherit (pkgs.fishPlugins.autopair) src;
      #     name = "autopair";
      #   }
      #   {
      #     inherit (pkgs.fishPlugins.done) src;
      #     name = "done";
      #   }
      #   {
      #     inherit (pkgs.fishPlugins.sponge) src;
      #     name = "sponge";
      #   }
      # ];
    };
  };
}
