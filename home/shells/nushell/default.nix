{
  pkgs,
  lib,
  ...
}: {
  config = {
    programs = {
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      # starship = {
      #   enable = true;
      # };
      atuin = {
        enable = true;
        enableNushellIntegration = true;
      };
      direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };
      nushell = {
        enable = true;
        configFile.source = ./config/config.nu;
        extraConfig = let
          conf = builtins.toJSON {
            show_banner = false;
            edit_mode = "vi";
            ls.clickable_links = true;
            rm.always_trash = true;

            table = {
              mode = "rounded";
              index_mode = "always";
              header_on_separator = false;
            };

            cursor_shape = {
              vi_insert = "line";
              vi_normal = "block";
            };

            menus = [
              {
                name = "completion_menu";
                only_buffer_difference = false;
                marker = "? ";
                type = {
                  layout = "columnar";
                  columns = 4;
                  col_padding = 2;
                };
                style = {
                  text = "magenta";
                  selected_text = "blue_reverse";
                  description_text = "yellow";
                };
              }
            ];
          };
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
          completions = names: builtins.foldl' (prev: str: "${prev}\n${str}") "" (map completion names);
        in ''
          $env.config = ${conf}
          ${completions ["git" "nix" "man" "cargo" "just"]}
        '';
        shellAliases = let
          g = lib.getExe pkgs.git;
          c = "cargo";
        in {
          # Cargo
          cb = "${c} build";
          cc = "${c} check";
          cn = "${c} new";
          cr = "${c} run";
          cs = "${c} search";
          ct = "${c} test";
          repl = "evcxr";

          # Git
          ga = "${g} add";
          gc = "${g} commit";
          gd = "${g} diff";
          gl = "${g} log";
          gs = "${g} status";
          gp = "${g} push origin main";

          # Miscellaneous
          cl = "clear";
          # y = "${pkgs.yazi}/bin/yazi";
          la = "ls -la";
          ll = "ls -l";
          n = "${pkgs.nitch}/bin/nitch";
          # vi = "nvim";
          zd = "zeditor";
          fz = "fzf --bind 'enter:become(hx {})'";
          powersave = "sudo cpupower frequency-set -g powersave";
          performance = "sudo cpupower frequency-set -g performance";
          # zi = "__zoxide_zi";
          keys = "ghostty +list-keybinds";

          # Nix
          fr = "nh os switch /home/jr/flaked";
          ft = "nh os test /home/jr/flaked";
          fu = "nh os switch --update /home/jr/flaked";
          upd = "nix-upgrade";
          cleanup = "nh clean all";
          opts = "man home-configuration.nix";
          jctl = "journalctl -p 3 -xb";
          ns = "nix-shell";
          nb = "nix-build";
          ne = "nix-instantiate --eval";

          # Replacements
          cat = "${pkgs.bat}/bin/bat";
          df = "${pkgs.duf}/bin/duf";
          find = "${pkgs.fd}/bin/fd";
          grep = "batgrep";
          tree = "${pkgs.eza}/bin/eza --git --icons --tree";
        };
      };
    };

    home.sessionVariables = {
      # STARSHIP_SHELL = "nu";
      # PROMPT_INDICATOR = "";
      # PROMPT_INDICATOR_VI_INSERT = ": ";
      # PROMPT_INDICATOR_VI_NORMAL = "> ";
      # PROMPT_MULTILINE_INDICATOR = "::: ";
      # DIRENV_LOG_FORMAT = "";
      # XDG_CONFIG_HOME = "~/.config";
      EDITOR = "hx";
      VISUAL = "hx";
      MANPAGER = "nvim +Man!";
    };

    xdg.configFile."nushell/style.nu".text = let
      colorscheme = "tokyonight_night";
      cs = import ./colorscheme.nix {inherit colorscheme;};
      colorscheme-dash = builtins.replaceStrings ["_"] ["-"] colorscheme;
    in ''
      def prompt_decorator [
        font_color: string
        bg_color: string
        symbol: string
        with_starship?: bool = true
      ] {
        let bg1 = if $with_starship { '${cs.white}' } else $bg_color
        let fg = {fg: $bg_color}
        let bg = {fg: $font_color bg: $bg_color}
        let startship_leading = if $with_starship { $"(ansi --escape {fg: $bg_color bg: $bg1})" } else ""
        $"($startship_leading)(ansi --escape $bg)($symbol)(ansi reset)(ansi --escape $fg)(ansi reset) "
      }

      let dev_tag = if (
        $nu.current-exe == (which nu).path.0
        or $nu.current-exe == '${pkgs.nushell}/bin/nu'
      ) { "" } else ' '
      $env.PROMPT_INDICATOR = {|| "> " }
      $env.PROMPT_INDICATOR_VI_INSERT = {|| prompt_decorator "${cs.black}" "${cs.light_green}" ($dev_tag + "󰏫") }
      $env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt_decorator "${cs.black}" "${cs.yellow}" ($dev_tag + "") }
      $env.LS_COLORS = (
        try {
          vivid generate ${colorscheme-dash} | str trim
        } catch {
          "" # Set LS_COLORS to an empty string if vivid fails
        }
      )
      $env.FZF_DEFAULT_OPTS = (
        "--layout reverse --header-first --tmux center,80%,60% "
        + "--pointer ▶ --marker 󰍕 --preview-window right,65% "
        + "--bind 'bs:backward-delete-char/eof,tab:accept-or-print-query,ctrl-t:toggle+down,ctrl-s:change-multi' "
        + $"--prompt '(prompt_decorator '${cs.black}' '${cs.green}' '▓▒░ ' false)' "
        + "--color=fg:${cs.white},hl:${cs.red} "
        + "--color=fg+:${cs.cyan},bg+:${cs.black},hl+:${cs.red} "
        + "--color=info:${cs.blue},prompt:${cs.yellow},pointer:${cs.red} "
        + "--color=marker:${cs.white},spinner:${cs.green},header:${cs.white}"
      )
    '';
  };
}
