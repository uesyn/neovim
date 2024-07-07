# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = name: url: branch: rev: let
    pname = "${strings.sanitizeDerivationName "${name}"}";
    version = rev;
    src = builtins.fetchGit {
      inherit url;
      ref = branch;
      rev = rev;
    };
  in
    pkgs.vimUtils.buildVimPlugin {
      inherit pname version src;
    };

  blame-nvim = mkNvimPlugin "blame.nvim" "https://github.com/FabijanZulj/blame.nvim.git" "main" "dedbcdce857f708c63f261287ac7491a893912d0";
  nvim-markdown = mkNvimPlugin "nvim-markdown" "https://github.com/ixru/nvim-markdown.git" "master" "75639723c1a3a44366f80cff11383baf0799bcb5";
  cellwidths-nvim = mkNvimPlugin "cellwidths.nvim" "https://github.com/delphinus/cellwidths.nvim.git" "main" "98d8b428020c7e0af098f316a02490e5b37e98da";

  unmanaged-plugins = [
    {
      plugin = blame-nvim;
      optional = true;
    }
    {
      plugin = nvim-markdown;
      optional = true;
    }
    { plugin = cellwidths-nvim; }
  ];
  plugins = with pkgs.vimPlugins; [
    # (nvim-treesitter.withPlugins (
    #   plugins:
    #     with plugins; [
    #       markdown
    #       markdown_inline
    #     ]
    # ))
    { plugin = lz-n; }
    {
      plugin = dracula-nvim;
      optional = false;
    }
    {
      plugin = plenary-nvim;
      optional = false;
    }
    {
      plugin = nvim-web-devicons;
      optional = false;
    }
    {
      plugin = barbar-nvim;
      optional = true;
    }
    {
      plugin = copilot-vim;
      optional = true;
    }
    {
      plugin = CopilotChat-nvim;
      optional = true;
    }
    {
      plugin = fzf-lua;
      optional = false;
    }
    {
      plugin = gitsigns-nvim;
      optional = true;
    }
    {
      plugin = neo-tree-nvim;
      optional = true;
    }
    {
      plugin = openingh-nvim;
      optional = true;
    }
    {
      plugin = nvim-osc52;
      optional = true;
    }
    {
      plugin = nvim-surround;
      optional = true;
    }

    {
      plugin = nvim-lspconfig;
      optional = false;
    }
    {
      plugin = cmp-nvim-lsp;
      optional = false;
    }
    {
      plugin = cmp-snippy;
      optional = false;
    }
    {
      plugin = nvim-snippy;
      optional = false;
    }
    {
      plugin = nvim-cmp;
      optional = true;
    }

    {
      plugin = fidget-nvim;
      optional = true;
    }
    {
      plugin = nvim-navic;
      optional = true;
    }
  ];

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }

  extraPackages = with pkgs; [
    bash
    bash-language-server
    fzf
    gopls
    jdt-language-server
    nil # nix LSP
    nodePackages.typescript-language-server
    pyright
    ripgrep
    rust-analyzer
  ];

  extraLuaPackages = with pkgs; [
    lua51Packages.tiktoken_core # depended by CopilotChat-nvim
  ];
in {
  neovim = mkNeovim {
    plugins = plugins ++ unmanaged-plugins;
    inherit extraPackages extraLuaPackages;
  };
}
