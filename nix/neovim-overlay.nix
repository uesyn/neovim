# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

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
    inherit extraPackages extraLuaPackages;
  };
}
