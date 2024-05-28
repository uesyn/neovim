# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = url: branch: rev:
    let
      pname = "${strings.sanitizeDerivationName "${url}"}";
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

  blame-nvim = mkNvimPlugin "https://github.com/FabijanZulj/blame.nvim.git" "main" "dedbcdce857f708c63f261287ac7491a893912d0";
  nvim-markdown = mkNvimPlugin "https://github.com/ixru/nvim-markdown.git" "master" "75639723c1a3a44366f80cff11383baf0799bcb5";

  unmanaged-plugins = [
    blame-nvim
    nvim-markdown
  ];
  plugins = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (
      plugins: with plugins; [
        markdown
        markdown_inline
      ]
    ))
    barbar-nvim
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-snippy
    copilot-vim
    dracula-nvim
    fidget-nvim
    fzf-lua
    gitsigns-nvim
    neo-tree-nvim
    nvim-cmp
    nvim-lspconfig
    nvim-osc52
    nvim-snippy
    nvim-surround
    openingh-nvim
    nvim-web-devicons
  ];

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

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
    fzf
    gopls
    nil # nix LSP
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    ripgrep
    rust-analyzer
  ];
in {
  neovim = mkNeovim {
    plugins = plugins ++ unmanaged-plugins;
    inherit extraPackages;
  };
}
