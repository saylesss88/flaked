{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.helix;
in {
  imports = [./languages.nix];
  options.custom.helix.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Helix Module";
  };

  config = lib.mkIf cfg.enable {
    programs.helix = with pkgs; {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.helix;
      defaultEditor = true;
      extraPackages = [
        biome
        clang-tools
        helix-gpt
        codeium
        nixpkgs-fmt
        nodePackages.prettier
        taplo-lsp
        vscode-langservers-extracted
        vscode-extensions.vadimcn.vscode-lldb
        lldb
        yaml-language-server
        wl-clipboard-rs
        scooter
        simple-completion-language-server
        topiary
        # ltex-ls
        hunspell
        hunspellDicts.en_US
        harper
      ];
      settings = {
        # theme = "rose_pine";
        theme = "tokyonight";

        editor = {
          # shell = [
          #   "nu"
          #   "-c"
          # ];
          color-modes = true;
          cursorline = true;
          bufferline = "multiple"; # or "always"
          line-number = "relative";
          rulers = [
            80
            120
          ];
          true-color = true;
          default-yank-register = "+";

          soft-wrap = {
            enable = false;
            # max-wrap = 10;
            # max-indent-retain = 14;
            # wrap-at-text-width = true;
          };

          auto-save = {
            focus-lost = true;
            after-delay.enable = true;
          };

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          file-picker = {
            hidden = false;
            ignore = false;
          };

          indent-guides = {
            character = "┊";
            render = true;
            skip-levels = 1;
          };

          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "warning";

          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };

          statusline = {
            left = [
              "mode"
              "spacer"
              "diagnostics"
              "spinner"
              "file-name"
            ];

            right = [
              "workspace-diagnostics"
              "spacer"
              "version-control"
              "spacer"
              "separator"
              "selections"
              "separator"
              "position"
              "position-percentage"
              "spacer"
            ];
            mode.normal = "";
            mode.insert = "I";
            mode.select = "S";
          };
        };
        keys = {
          normal = {
            H = ":buffer-previous"; # Shift+H & Shift+L to cycle buffers
            L = ":buffer-next";
            space = {
              "." = ":fmt";
            };
            space.t = {
              s = ":toggle soft-wrap.enable";
            };
            C-g = [
              ":write-all"
              ":new"
              ":insert-output lazygit"
              ":buffer-close!"
              ":redraw"
              ":reload-all"
            ];
            C-r = [
              ":write-all"
              ":insert-output scooter >/dev/tty"
              ":redraw"
              ":reload-all"
            ];
            C-y = [
              ":sh rm -f /tmp/unique-file"
              ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
              ":insert-output echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
              ":open %sh{cat /tmp/unique-file}"
              ":redraw"
            ];
            space = {
              e = [
                ":sh rm -f /tmp/unique-file-h21a434"
                ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/unique-file-h21a434"
                ":insert-output echo \"x1b[?1049h\" > /dev/tty"
                ":open %sh{cat /tmp/unique-file-h21a434}"
                ":redraw"
              ];
              E = [
                ":sh rm -f /tmp/unique-file-u41ae14"
                ":insert-output yazi '%{workspace_directory}' --chooser-file=/tmp/unique-file-u41ae14"
                ":insert-output echo \"x1b[?1049h\" > /dev/tty"
                ":open %sh{cat /tmp/unique-file-u41ae14}"
                ":redraw"
              ];
            };
          };
        };
      };

      # themes = {
      #   # https://github.com/helix-editor/helix/blob/master/runtime/themes/gruvbox.toml
      #   gruvbox_community = {
      #     inherits = "gruvbox";
      #     "variable" = "blue1";
      #     "variable.parameter" = "blue1";
      #     "function.macro" = "red1";
      #     "operator" = "orange1";
      #     "comment" = "gray";
      #     "constant.builtin" = "orange1";
      #     "ui.background" = { };
      #   };
      # };
    };
  };
}
