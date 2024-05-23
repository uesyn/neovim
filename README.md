This is my neovim environment

## :bicyclist: Test drive

If you have Nix installed (with [flakes](https://wiki.nixos.org/wiki/Flakes) enabled),
you can test drive this by running:

```console
nix run "github:uesyn/neovim"
```

## :zap: Installation

### :snowflake: NixOS (with flakes)

1. Add your flake to you NixOS flake inputs.
1. Add the overlay provided by this flake.

```nix
nixpkgs.overlays = [
    # replace <derivation> with the name you chose
    <derivation>.overlays.default
];
```

You can then add the overlay's output(s) to the `systemPackages`:

```nix
environment.systemPackages = with pkgs; [
    nvim-pkg # The default package added by the overlay
];
```

> [!IMPORTANT]
>
> This flake uses `nixpkgs.wrapNeovimUnstable`, which has an
> unstable signature. If you set `nixpkgs.follows = "nixpkgs";`
> when importing this into your flake.nix, it may break.
> Especially if your nixpkgs input pins a different branch.

### :penguin: Non-NixOS

With Nix installed (flakes enabled), from the repo root:

```console
nix profile install .#nvim
```

## :robot: Design

Directory structure:

```sh
── flake.nix
── nvim # Neovim configs (lua), equivalent to ~/.config/nvim
── nix # Nix configs
```

### :open_file_folder: Nix

You can declare Neovim derivations in `nix/neovim-overlay.nix`.

There are two ways to add plugins:

- The traditional way, using `nixpkgs` as the source.
- By adding plugins as flake inputs (if you like living on the bleeding-edge).
  Plugins added as flake inputs must be built in `nix/plugin-overlay.nix`.

Directory structure:

```sh
── flake.nix
── nix
  ├── mkNeovim.nix # Function for creating the Neovim derivation
  └── neovim-overlay.nix # Overlay that adds Neovim derivation
```
