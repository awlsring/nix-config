{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./lsp.nix
    # ./syntax.nix
    # ./ui.nix
  ];

  programs.neovim = let
  in {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./config/init.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      {
        plugin = comment-nvim;
        type = "lua";
        config = "require(\"Comment\").setup()";
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          ${builtins.readFile ./config/plugin/telescope.lua}
        '';
      }
      {
        plugin = telescope-fzf-native-nvim;
      }
      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-javascript
          p.tree-sitter-typescript
          p.tree-sitter-go
          p.tree-sitter-rust
          p.tree-sitter-html
          p.tree-sitter-css
          p.tree-sitter-tsx
          p.tree-sitter-toml
          p.tree-sitter-yaml
          p.tree-sitter-json
        ]);
        type = "lua";
        config = ''
          ${builtins.readFile ./config/plugin/treesitter.lua}
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          ${builtins.readFile ./config/plugin/lualine.lua}
        '';
      }
      {
        plugin = lspkind-nvim;
      }
      {
        plugin = neo-tree-nvim;
      }
      {
        plugin = nvim-web-devicons;
      }
    ];

    extraPackages = with pkgs; [
      xclip
      wl-clipboard
      luajitPackages.lua-lsp
    ];
  };
}
