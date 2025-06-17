{pkgs, ...}: {
  programs.helix = {
    languages = {
      language-server.biome = {
        command = "biome";
        args = ["lsp-proxy"];
      };

      language-server.gpt = {
        command = "helix-gpt";
        args = [
          "--handler"
          "codeium"
        ];
      };
      language-server.codeium = {
        # Your Codeium handler
        command = "helix-gpt";
        args = [
          "--handler"
          "codeium"
        ];
      };

      language-server.rust-analyzer.config = {
        check = {
          command = "clippy";
        };
        check.features = "all";
        check.always = true;
        cargo.toolchain = "nightly";
        cargo.buildScripts.rebuildOnSave = true;
        cargo.buildScripts.enable = true;
        cargo.autoreload = true;
        cargo.procMacro.enable = true;
        cargo.procMacro.ignored.leptos_macro = [
          "server"
          "component"
        ];
        cargo.diagnostics.disables = ["unresolved-proc-macro"];
        cargo.allFeatures = true;
      };

      language-server.scls = {
        command = "simple-completion-language-server";
      };

      language-server.scls.config = {
        max_completion_items = 100;
        feature_words = true;
        feature_snippets = true;
        snippets_first = true;
        snippets_inline_by_word_tail = false;
        feature_unicode_input = false;
        feature_paths = true;
        feature_citations = false;
      };

      language-server.scls.environment = {
        RUST_LOG = "info,simple-completion-language-server=info";
        LOG_FILE = "/tmp/completion.log";
      };

      language-server.yaml-language-server.config.yaml.schemas = {
        kubernetes = "k8s/*.yaml";
      };

      language-server.harper-ls = {
        command = "harper-ls";
        args = ["--stdio"];
      };

      language-server.harper-ls.config.harper-ls = {
        diagnosticSeverity = "warning";
        linters.spaces = false;
      };

      language = [
        {
          name = "css";
          language-servers = [
            "vscode-css-language-server"
            "gpt"
          ];
          formatter = {
            command = "prettier";
            args = [
              "--stdin-filepath"
              "file.css"
            ];
          };
          auto-format = true;
        }
        # {
        #   name = "go";
        #   language-servers = [ "gopls" "golangci-lint-lsp" "gpt" ];
        #   formatter = { command = "goimports"; };
        #   auto-format = true;
        # }
        {
          name = "html";
          language-servers = [
            "vscode-html-language-server"
            "gpt"
          ];
          formatter = {
            command = "prettier";
            args = [
              "--stdin-filepath"
              "file.html"
            ];
          };
          auto-format = true;
        }
        {
          name = "json";
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = ["format"];
            }
            "biome"
          ];
          formatter = {
            command = "biome";
            args = [
              "format"
              "--indent-style"
              "space"
              "--stdin-file-path"
              "file.json"
            ];
          };
          auto-format = true;
        }
        {
          name = "jsonc";
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = ["format"];
            }
            "biome"
          ];
          formatter = {
            command = "biome";
            args = [
              "format"
              "--indent-style"
              "space"
              "--stdin-file-path"
              "file.jsonc"
            ];
          };
          file-types = [
            "jsonc"
            "hujson"
          ];
          auto-format = true;
        }
        {
          name = "markdown";
          text-width = 80;
          soft-wrap.wrap-at-text-width = true;
          language-servers = [
            "marksman"
            "markdown-oxide"
            "gpt"
            "codeium"
            "harper-ls"
            # "ltex-ls"
          ];
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "markdown"
              "--prose-wrap"
              "always"
              # "--stdin-filepath"
              # "file.md"
            ];
          };
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          language-servers = [
            "nil"
            "typos"
            "nixd"
            "gpt"
            "codeium"
          ];
          file-types = ["nix"];
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
        }
        {
          name = "nu";
          auto-format = true;
          formatter = {
            command = "topiary";
            args = [
              "format"
              "--language"
              "nu"
            ];
          };
        }
        {
          name = "rust";
          language-servers = [
            "scls"
            "rust-analyzer"
            "gpt"
          ];
          scope = "source.rust";
          injection-regex = "rs|rust";
          file-types = ["rs"];
          roots = [
            "Cargo.toml"
            "Cargo.lock"
          ];
          shebangs = [
            "rust-script"
            "cargo"
          ];
          formatter = {
            command = "rustfmt";
            args = ["--edition=2024"];
          };
          comment-tokens = [
            "//"
            "///"
            "//!"
          ];
          auto-format = true;
        }
        {
          name = "git-commit";
          language-servers = ["scls"];
        }
        {
          name = "stub";
          scope = "text.stub";
          file-types = [];
          shebangs = [];
          roots = [];
          auto-format = false;
          language-servers = ["scls"];
        }
        {
          name = "scss";
          language-servers = [
            "vscode-css-language-server"
            "gpt"
          ];
          formatter = {
            command = "prettier";
            args = [
              "--stdin-filepath"
              "file.scss"
            ];
          };
          auto-format = true;
        }
        {
          name = "toml";
          language-servers = ["taplo"];
          formatter = {
            command = "taplo";
            args = [
              "fmt"
              "-o"
              "column_width=120"
              "-"
            ];
          };
          auto-format = true;
        }
        {
          name = "bash";
          language-servers = [
            "bash-language-server"
            "gpt"
            "codeium"
          ];
          file-types = ["sh"];
        }
        {
          name = "yaml";
          language-servers = ["yaml-language-server"];
          formatter = {
            command = "prettier";
            args = [
              "--stdin-filepath"
              "file.yaml"
            ];
          };
          auto-format = true;
        }
      ];
    };
  };
}
