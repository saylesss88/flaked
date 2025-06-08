{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];
  options.custom.nvfModule.enable = lib.mkEnableOption "Setup nvf";
  config = lib.mkIf config.custom.nvfModule.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
          theme.enable = true;
          theme.name = "gruvbox";
          theme.transparent = true;
          theme.style = "dark";

          options = {
            clipboard = "unnamedplus";
            tabstop = 2;
            shiftwidth = 2;
            wrap = false;
            expandtab = true;
            autoindent = true;
            mouse = "a";
          };

          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;

          autocomplete.nvim-cmp.config = lib.generators.mkLuaInline ''
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                # THIS IS THE KEY CHANGE: Map <C-y> to accept
                ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Keep Enter for explicit confirmation if desired, or remove
                -- Alternatively, to completely disable Enter for completion:
                -- ['<CR>'] = cmp.mapping.noop(),
                ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  -- You might also want to add tab-completion for snippets if using luasnip
                  -- elseif luasnip.expand_or_jumpable() then
                  --   luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  -- elseif luasnip.jumpable(-1) then
                  --   luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
              }),
              # Other nvim-cmp settings can go here if needed
              # For example, sources, formatting, etc.
            })
          '';

          mini = {
            starter = {
              enable = true;
              setupOpts = {
                header =
                  "  ／l、     \n"
                  + "（ﾟ､ ｡ ７  \n"
                  + " l  ~ ヽ    \n"
                  + " じしf_,)ノ \n";
                footer = " ";
              };
            };
          };

          autopairs.nvim-autopairs.enable = true;

          git.enable = true;

          lsp = {
            enable = true;
            formatOnSave = true;
            lspkind.enable = true;
            trouble.enable = true;
            lspSignature.enable = true;
          };

          diagnostics = {
            enable = true;
            config = {
              signs = {
                text = {
                  "vim.diagnostic.severity.ERROR" = " ";
                  "vim.diagnostic.severity.WARN" = " ";
                  "vim.diagnostic.severity.HINT" = " ";
                  "vim.diagnostic.severity.INFO" = " ";
                };
              };
              underline = true;
              virtual_lines = true;
              virtual_text = {
                format = lib.generators.mkLuaInline ''
                  function(diagnostic)
                    return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                  end
                '';
              };
            };
            nvim-lint.enable = true;
          };

          languages = {
            enableFormat = true;
            enableExtraDiagnostics = true;
            enableTreesitter = true;

            nix.enable = true;
            markdown.enable = true;

            clang.enable = true;
            css.enable = true;
            html.enable = true;
            lua.enable = true;
            python.enable = true;
            rust = {
              enable = true;
              lsp.enable = true;
              dap.enable = true;
              format.enable = true;
              format.package = pkgs.rust-analyzer;
              crates = {
                enable = true;
              };
            };
            # fails on darwin
            #tailwind.enable = true;
          };

          formatter.conform-nvim.enable = true;

          visuals = {
            nvim-web-devicons.enable = true;
            indent-blankline.enable = true;
          };

          snippets.luasnip.enable = true;

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          ui = {
            borders.enable = false;
          };

          autocmds = [
            {
              event = ["VimEnter"];
              command = "highlight StatusLine guibg=none | highlight StatusLineNC guibg=none";
            }
          ];

          statusline.lualine.enable = true;
          tabline = {
            nvimBufferline.enable = true;
          };
        };
      };
    };
  };
}
