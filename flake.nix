{
  description = "My Home manager Flake!";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    utils = {
      url = "github:numtide/flake-utils";
    };


    # ---- Nix Homebrew Stuff ----
    # https://github.com/zhaofengli/nix-homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    #--------------------------------------



    # this is a quick util a good GitHub samaritan wrote to solve for
    # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1791545015
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };
  };

  # https://stackoverflow.com/questions/77585228/how-to-allow-unfree-packages-in-nix-for-each-situation-nixos-nix-nix-wit

  outputs =
    { self
    , nixpkgs
    , darwin
    , home-manager
    , ragenix
    , utils
    , mac-app-util
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , ...
    } @ inputs:
    let
      # Import Work Certs
      certificates = import ./certificates.nix;


      # https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050?permalink_comment_id=4054744 - this is where some code comes from
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      nixpkgsConfig = {
        config = { allowUnfree = true; };
        # overlays = attrValues self.overlays ++ singleton (
        #   # Sub in x86 version of packages that don't build on Apple Silicon yet
        #   final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        #     #     inherit (final.pkgs-x86)              
        #     #       nix-index
        #     #       niv;
        #   })
        # );
      };


      work_nix_config = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
          pkgs.neofetch

          # If this line is uncommented i get a big error
          pkgs.fastfetch
        ];

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;


        nix.settings = {
          experimental-features = "nix-command flakes recursive-nix";
          # https://github.com/LnL7/nix-darwin/issues/740#issuecomment-1984439237 - to fix nix-shell -p
          extra-nix-path = "nixpkgs=flake:nixpkgs";

          trusted-users = [
            "root"
            "jstein"
          ];
        };

        # Imported from certificates.nix
        security.pki.certificates = certificates;

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };


      allowed-unfree-packages = [
        "vscode"
        "vscode-extension-github-copilot"
        "discord"
        "signal-desktop"

      ];

    in
    {




      # ------- X86 Nix OS Config -----------
      nixosConfigurations = {

        imac = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            ragenix.nixosModules.default
            {
              imports = [
                ./hosts/imac/configuration.nix
              ];
              _module.args.self = self;

            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;
              home-manager.users.jstein = {
                imports = [
                  ./hosts/imac/home.nix
                ];
                _module.args.self = self;
                _module.args.host = "imac";
                _module.args.inputs = inputs;
              };
            }
          ];
        };
      };

      # ------ (Work) Darwin Config ---------------
      darwinConfigurations = {
        work-mac = darwin.lib.darwinSystem {

          # This is something good usually


          system = "aarch64-darwin";
          modules = [

            # OSX Specific
            ./modules/osx/system.nix

            # Configure HomeBrew
            nix-homebrew.darwinModules.nix-homebrew
            {
              imports = [
                (import ./modules/homebrew.nix {
                  # Pass in homebrew cask/core
                  inherit homebrew-cask homebrew-core;
                }
                )
              ];

            }


            mac-app-util.darwinModules.default

            work_nix_config
            {
              imports = [
                ./hosts/work-mac/configuration.nix
              ];
              _module.args.self = self;

              security.pki.certificates = certificates;

            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;

              users.users.jstein = {
                home = "/Users/jstein";
              };
              home-manager.users.jstein = {

                manual.manpages.enable = false; # Was getting error on this

                imports = [
                  mac-app-util.homeManagerModules.default
                  ./hosts/work-mac/home.nix
                ];
              };
            }
          ];
        };
      };

      overlays = {
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;

          };


        };


      };

      # Standalone Home manager Config Attempt (probably a fail however)
      homeConfigurations."jstein@linux-64" = home-manager.lib.homeManagerConfiguration
        {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit allowed-unfree-packages; };
          modules = [ ./hosts/non-nix-linux/home.nix ];
          #Could have this moudle instead ... ./home-manager/users/${user}.nix
        };
    };
}
