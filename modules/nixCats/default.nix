# Copyright (c) 2023 BirdeeHub 
# Licensed under the MIT license 
/* 
  # paste the inputs you don't have in this set into your main system flake.nix
  # (lazy.nvim wrapper only works on unstable)
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  Then call this file with:
  myNixCats = import ./path/to/this/dir { inherit inputs; };
  And the new variable myNixCats will contain all outputs of the normal flake format.
  You could put myNixCats.packages.${pkgs.system}.thepackagename in your packages list.
  You could install them with the module and reconfigure them too if you want.
  You should definitely re export them under packages.${system}.packagenames
  from your system flake so that you can still run it via nix run from anywhere.

  The following is just the outputs function from the flake template.
 */
{inputs, flake-path ? "/home/jackwenyoung/codes/jackwy/jackwy-nixos", ... }@attrs: let
  inherit (inputs) nixpkgs; # <-- nixpkgs = inputs.nixpkgsSomething;
  inherit (inputs.nixCats) utils;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  # will not apply to module imports
  # as that will have your system values
  extra_pkg_config = {
    allowUnfree = true;
  };
  dependencyOverlays = /* (import ./overlays inputs) ++ */ [
    # see :help nixCats.flake.outputs.overlays
    # This overlay grabs all the inputs named in the format
    # `plugins-<pluginName>`
    # Once we add this overlay to our nixpkgs, we are able to
    # use `pkgs.neovimPlugins`, which is a set of our plugins.
    (utils.standardPluginOverlay inputs)
    # add any flake overlays here.

    # when other people mess up their overlays by wrapping them with system,
    # you may instead call this function on their overlay.
    # it will check if it has the system in the set, and if so return the desired overlay
    # (utils.fixSystemizedOverlay inputs.codeium.overlays
    #   (system: inputs.codeium.overlays.${system}.default)
    # )
  ];

  categoryDefinitions = { pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {

    lspsAndRuntimeDeps = with pkgs; {
      general = {
        core = [
          universal-ctags
          ripgrep
          fd
          ast-grep
          lazygit
        ];
        other = [
          sqlite
        ];
        markdown = [
          marksman
          python312Packages.pylatexenc
          harper
        ];
      };
      lua = [
        lua-language-server
        stylua
      ];
      nix = [
        nix-doc
        nil
        nixd
        nixfmt-rfc-style
      ];
      neonixdev = [
        nix-doc
        nil
        lua-language-server
        nixd
        nixfmt-rfc-style
      ];
      python = [
        basedpyright
        isort
        ruff
      ];
    };

    startupPlugins = with pkgs.vimPlugins; {
      theme = builtins.getAttr (extra.colorscheme or "catppuccin-mocha") {
        "onedark" = onedark-nvim;
        "catppuccin" = catppuccin-nvim;
        "catppuccin-mocha" = catppuccin-nvim;
        "tokyonight" = tokyonight-nvim;
        "tokyonight-day" = tokyonight-nvim;
      };
      general = [
        lze
        vim-repeat
        nvim-nio
        nvim-notify
        nvim-web-devicons
        nvim-lspconfig
        plenary-nvim
        mini-nvim
        snacks-nvim
      ];
      lua = [
        luvit-meta
      ];
      neonixdev = [
        luvit-meta
      ];
      treesitter = [
        nvim-treesitter-textobjects
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            bash
            fish
            nix
            lua
            python
            markdown
            go
            javascript
            html
            css
            astro
            yaml
            toml
            json
          ]
        ))
      ];

    };

    optionalPlugins = with pkgs.vimPlugins; {
      general = {
        markdown = [
          render-markdown-nvim
          markdown-preview-nvim
        ];
        core = [
          fzf-lua
          which-key-nvim
          nvim-surround
          conform-nvim
          undotree
          vim-sleuth
          lualine-lsp-progress
          lualine-nvim
          yazi-nvim
          pkgs.neovimPlugins.houdini
          bufferline-nvim
          treesj
        ];
        cmp = [
          blink-cmp
          luasnip
          friendly-snippets
        ];
      };
      otter = [
        otter-nvim
      ];
      python = [
        nvim-dap-python
      ];
      neonixdev = [
        lazydev-nvim
      ];
      debug = [
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
      ];
      other = [
        pkgs.neovimPlugins.hlargs
      ];

    };

    # shared libraries to be added to LD_LIBRARY_PATH
    # variable available to nvim runtime
    sharedLibraries = {};

    environmentVariables = {};

    extraWrapperArgs = {};
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh

    # lists of the functions you would have passed to
    # python.withPackages or lua.withPackages

    # get the path to this python environment
    # in your lua config via
    # vim.g.python3_host_prog
    # or run from nvim terminal via :!<packagename>-python3
    extraPython3Packages = {
      python = (py:[
        py.debugpy
        py.pylsp-mypy
        py.pyls-isort
	py.pytest
      ]);
    };
    # populates $LUA_PATH and $LUA_CPATH
    extraLuaPackages = {
      test = [ (_:[]) ];
    };

  };

  jackwyvim_settings = { pkgs, ...}@misc: {
    wrapRc = true;
    withNodeJs = true;
    withPython3 = true;
    viAlias = false;
    vimAlias = false;
    unwrappedCfgPath = "${flake-path}/modules/nixCats";
  };

  jackwyvim_categories = { pkgs, ...}@misc: {
    theme = true;
    general = true;
    otter = true;
    lua = true;
    python = true;
    neonixdev = true;
    debug = true;
    treesitter = true;
  };

  jackwyvim_extra = { pkgs, ...}@misc: {
    colorscheme = "catppuccin-mocha";
  };

  packageDefinitions = {
    # NOTE: args allow to override attributes set.
    ncat = args: {
      # they contain a settings set defined above
      # see :help nixCats.flake.outputs.settings
      settings = jackwyvim_settings args // {
        aliases = [ "vim" ];
      };
      # and a set of categories that you want
      # (and other information to pass to lua)
      categories = jackwyvim_categories args // {
      };
      extra = jackwyvim_extra args // {
      };
    };
    tcat = args: {
      settings = jackwyvim_settings args // {
        wrapRc = false;
        aliases = [ "tvim" ];
      };
      # and a set of categories that you want
      # (and other information to pass to lua)
      categories = jackwyvim_categories args // {
      };
      extra = jackwyvim_extra args // {
      };
    };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "ncat";
in
  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit system dependencyOverlays extra_pkg_config nixpkgs;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in {
    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
      moduleNamespace = [ "jackwySystemMods" defaultPackageName];
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
      moduleNamespace = [ "jackwyHMMods" defaultPackageName];
    };
  in {

  # these outputs will be NOT wrapped with ${system}

  # this will make an overlay out of each of the packageDefinitions defined above
  # and set the default overlay to the one named here.
  overlays = utils.makeOverlays luaPath {
    # we pass in the things to make a pkgs variable to build nvim with later
    inherit nixpkgs dependencyOverlays extra_pkg_config;
    # and also our categoryDefinitions
  } categoryDefinitions packageDefinitions defaultPackageName;

  nixosModules.default = nixosModule;
  homeModules.default = homeModule;

  inherit utils nixosModule homeModule;
  inherit (utils) templates;
})
