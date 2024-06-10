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
    # Regexes for config files to ignore, relative to the nvim directory.
    # e.g. [ "^plugin/neogit.lua" "^ftplugin/.*.lua" ]
    ignoreConfigRegexes ? [],
    extraPackages ? [], # Extra runtime dependencies (e.g. ripgrep, ...)
    extraLuaPackages ? [], # Additional lua packages (not plugins, e.g. lua51Packages.tiktoken_core)
    withPython3 ? false, # Build Neovim with Python 3 support?
    withRuby ? false, # Build Neovim with Ruby support?
    withNodeJs ? false, # Build Neovim with NodeJS support?
    viAlias ? true, # Add a "vi" binary to the build output as an alias?
    vimAlias ? true, # Add a "vim" binary to the build output as an alias?
  }: let
    # This is the structure of a plugin definition.
    # Each plugin in the `plugins` argument list can also be defined as this attrset
    defaultPlugin = {
      plugin = null; # e.g. nvim-lspconfig
      config = null; # plugin config
      optional = false;
      runtime = {};
    };

    externalPackages = extraPackages;

    # Map all plugins to an attrset { plugin = <plugin>; config = <config>; optional = <tf>; ... }
    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    # This nixpkgs util function creates an attrset
    # that pkgs.wrapNeovimUnstable uses to configure the Neovim build.
    neovimConfig = pkgs-wrapNeovim.neovimUtils.makeNeovimConfig {
      inherit withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    # This uses the ignoreConfigRegexes list to filter
    # the nvim directory
    nvimRtpSrc = let
      src = ../nvim;
    in
      lib.cleanSourceWith {
        inherit src;
        name = "nvim-rtp-src";
        filter = path: tyoe: let
          srcPrefix = toString src + "/";
          relPath = lib.removePrefix srcPrefix (toString path);
        in
          lib.all (regex: builtins.match regex relPath == null) ignoreConfigRegexes;
      };

    # Split runtimepath into 2 directories:
    # - nvim, containing plugin, ftplugin, ... subdirectories
    # - after, to be sourced last in the startup initialization
    # See also: https://neovim.io/doc/user/starting.html
    nvimRtp = stdenv.mkDerivation {
      name = "nvim-rtp";
      src = nvimRtpSrc;

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
      (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ ["--add-flags" (escapeShellArg ''--cmd "set rtp^=${nvimRtp},${nvimRtp}/after"'')]
    );

    luaPackages = pkgs.neovim-unwrapped.lua.pkgs;

    # Native Lua libraries
    extraMakeWrapperLuaCArgs =
      optionalString (extraLuaPackages != [])
      ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath extraLuaPackages}"'';

    # Lua libraries
    extraMakeWrapperLuaArgs =
      optionalString (extraLuaPackages != [])
      ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath extraLuaPackages}"'';

    neovim-wrapped = pkgs-wrapNeovim.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig
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
    neovim-wrapped.overrideAttrs (oa: {
      buildPhase = oa.buildPhase;
    })
