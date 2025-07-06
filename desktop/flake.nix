{
  description = "Nix OS system flake for host *north*.";

  inputs = {
    # Pull Nixpkgs from the latest unstable channel.  Change to
    #   "nixos-24.11" or another branch if you want something stabler.
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";

    # Utility helpers (not strictly required here, but handy if you later
    # add devShells, overlays, etc.).
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    
    # ──────────────────────────────────────────────────────────────────
    # NixOS system declaration
    # ──────────────────────────────────────────────────────────────────
    nixosConfigurations.north = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # If you need to pass extra values to your modules, expose them here.
      # specialArgs = { inherit self; };

      # Re‑use the same configuration.nix you’ve been editing all along.
      # You can freely keep using hardware‑configuration.nix — the import
      # inside your configuration file still works fine.
      modules = [
        ./configuration.nix
        #./modules/plasma.nix
        ./modules/ollama.nix
        #./modules/bottles.nix

      ];
    };
  };
}

