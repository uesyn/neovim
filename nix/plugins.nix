{pkgs}: let
  # Use this to create a plugin from a flake input
  mkNvimPlugin = name: url: branch: rev: let
    pname = "${pkgs.lib.strings.sanitizeDerivationName "${name}"}";
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

  unmanaged-plugins = {
    blame_nvim = blame-nvim;
    nvim_markdown = nvim-markdown;
    cellwidths_nvim = cellwidths-nvim;
  };
  managed-plugins = with pkgs.vimPlugins; {
    lazy_nvim = lazy-nvim;
    dracula_nvim = dracula-nvim;
    plenary_nvim = plenary-nvim;
    nvim_web_devicons = nvim-web-devicons;
    barbar_nvim = barbar-nvim;
    copilot_lua = copilot-lua;
    copilot_cmp = copilot-cmp;
    copilotchat_nvim = CopilotChat-nvim;
    fzf_lua = fzf-lua;
    gitsigns_nvim = gitsigns-nvim;
    neo_tree_nvim = neo-tree-nvim;
    nui_nvim = nui-nvim;
    openingh_nvim = openingh-nvim;
    nvim_osc52 = nvim-osc52;
    nvim_surround = nvim-surround;
    nvim_lspconfig = nvim-lspconfig;
    cmp_nvim_lsp = cmp-nvim-lsp;
    cmp_snippy = cmp-snippy;
    nvim_snippy = nvim-snippy;
    nvim_cmp = nvim-cmp;
    fidget_nvim = fidget-nvim;
    nvim_navic = nvim-navic;
    hop_nvim = hop-nvim;
  };
in
  unmanaged-plugins // managed-plugins
