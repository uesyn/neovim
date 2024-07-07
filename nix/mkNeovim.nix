# Function for creating a Neovim derivation
{
  pkgs,
  lib,
  stdenv,
  # Set by the overlay to ensure we use a compatible version of `wrapNeovimUnstable`
  pkgs-wrapNeovim ? pkgs,
}:
with lib;
  {
    plugins ? [], # List of plugins
    # The Neovim package to wrap
    neovim-unwrapped ? pkgs-wrapNeovim.neovim-unwrapped,
    extraPackages ? [], # Extra runtime dependencies (e.g. ripgrep, ...)
    extraLuaPackages ? [], # Additional lua packages (not plugins, e.g. lua51Packages.tiktoken_core)
    withPython3 ? false,
    withRuby ? false,
    withNodeJs ? false,
    viAlias ? true,
    vimAlias ? true,
  }: let
    # This nixpkgs util function creates an attrset
    # that pkgs.wrapNeovimUnstable uses to configure the Neovim build.
    neovimConfig = pkgs-wrapNeovim.neovimUtils.makeNeovimConfig {
      inherit withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = plugins;
    };

    nvimRtp = stdenv.mkDerivation {
      name = "nvim-rtp";
      src = ../nvim;

      buildPhase = ''
        mkdir -p $out
        rm init.lua
      '';

      installPhase = ''
        cp -r * $out
      '';
    };

    initLua = builtins.readFile ../nvim/init.lua;

    # Add arguments to the Neovim wrapper script
    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      (optional (extraPackages != [])
        ''--prefix PATH : "${makeBinPath extraPackages}"'')
      ++ ["--add-flags" (escapeShellArg ''--cmd "set rtp^=${nvimRtp},${nvimRtp}/after"'')]
    );

    luaPackages = neovim-unwrapped.lua.pkgs;

    # Native Lua libraries
    extraMakeWrapperLuaCArgs =
      optionalString (extraLuaPackages != [])
      ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath extraLuaPackages}"'';

    # Lua libraries
    extraMakeWrapperLuaArgs =
      optionalString (extraLuaPackages != [])
      ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath extraLuaPackages}"'';

    neovim-wrapped = pkgs-wrapNeovim.wrapNeovimUnstable neovim-unwrapped (neovimConfig
      // {
        luaRcContent = initLua;
        wrapperArgs =
          extraMakeWrapperArgs
          + " "
          + escapeShellArgs neovimConfig.wrapperArgs
          + " "
          + extraMakeWrapperLuaCArgs
          + " "
          + extraMakeWrapperLuaArgs;
        wrapRc = true;
      });
  in
    neovim-wrapped
