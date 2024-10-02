{
  config,
  pkgs,
  lib,
  ...
}: {
  options.neovim = {
    enable = lib.mkEnableOption "enable neovim";
  };

  config = lib.mkIf config.neovim.enable {
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
          plugin = telescope-ui-select-nvim;
        }
        {
          plugin = none-ls-nvim;
          type = "lua";
          config = ''
            ${builtins.readFile ./config/plugin/null-ls.lua}
          '';
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
            p.tree-sitter-templ
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
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            ${builtins.readFile ./config/plugin/lsp.lua}
          '';
        }

        # Completions
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            ${builtins.readFile ./config/plugin/cmp.lua}
          '';
        }
        ## Snippets
        {
          plugin = luasnip;
        }
        {
          plugin = cmp_luasnip;
        }
        {
          plugin = friendly-snippets;
        }
        ## LSP
        {
          plugin = cmp-nvim-lsp;
        }
        ## LLM
        {
          plugin = copilot-vim;
        }

        # Git
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''
            ${builtins.readFile ./config/plugin/git.lua}
          '';
        }
        {
          plugin = vim-fugitive;
        }

        # Dashboard
        {
          plugin = alpha-nvim;
          type = "lua";
          config = ''
            ${builtins.readFile ./config/plugin/alpha.lua}
          '';
        }
        # tmux
        {
          plugin = vim-tmux-navigator;
          type = "lua";
          config = ''
            vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', {})
            vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', {})
            vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', {})
            vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', {})
          '';
        }
        # tests
        {
          plugin = vimux;
        }
        {
          plugin = nvim-test;
          type = "lua";
          config = ''
            ${builtins.readFile ./config/plugin/nvim-test.lua}
          '';
        }
      ];

      extraPackages = with pkgs; [
        # LSP deps
        gopls
        golangci-lint-langserver
        rust-analyzer
        dockerfile-language-server-nodejs
        pyright
        nodePackages.typescript-language-server
        lua-language-server

        # Formatters
        stylua
        black
        codespell
        goimports-reviser
        prettierd
        shfmt
        rustfmt

        # Diagnostics
        shellcheck
        golangci-lint
        pylint
        go-tools
        yamllint
        eslint_d

        # Others
        xclip
        wl-clipboard
        luajitPackages.lua-lsp
      ];
    };
  };
}
