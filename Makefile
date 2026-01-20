# Makefile for building and deploying NixOS configurations

# Define hosts
NIXOS_HOSTS := north minibook rukako
DARWIN_HOSTS := macbook

# --- Build Targets ---

# Build all NixOS hosts
build: $(addprefix build-,$(NIXOS_HOSTS))

# Generic build target for NixOS hosts
build-%:
	@echo "Building NixOS configuration for $*..."
	nixos-rebuild build --flake .#$*

# Build all Darwin hosts
build-darwin: $(addprefix build-,$(DARWIN_HOSTS))

# Generic build target for Darwin hosts
build-macbook:
	@echo "Building Darwin configuration for macbook..."
	darwin-rebuild build --flake .#macbook

# --- Deploy Targets ---

# Deploy to all NixOS hosts
deploy: $(addprefix deploy-,$(NIXOS_HOSTS))

# Generic deploy target for NixOS hosts
# Usage: make deploy-north
deploy-%:
	@echo "Deploying to $*..."
	nixos-rebuild switch --flake .#$* --target-host root@$*

# Special deploy target for rukako with a specific IP
deploy-rukako:
	@echo "Deploying to rukako (192.168.88.8)..."
	nixos-rebuild switch --flake .#rukako --target-host root@192.168.88.8

# Deploy to all Darwin hosts
deploy-darwin: $(addprefix deploy-,$(DARWIN_HOSTS))

# Deploy to macbook (locally)
deploy-macbook:
	@echo "Deploying to macbook..."
	darwin-rebuild switch --flake .#macbook

# --- Proxmox LXC ---

# Build the Proxmox LXC template
proxmox-lxc:
	@echo "Building Proxmox LXC template..."
	nix build .#proxmox-lxc

# --- Help ---

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  build              - Build all NixOS host configurations"
	@echo "  build-<hostname>   - Build a specific NixOS host (e.g., build-north)"
	@echo "  build-darwin       - Build all Darwin host configurations"
	@echo "  build-macbook      - Build the macbook Darwin configuration"
	@echo ""
	@echo "  deploy             - Deploy to all NixOS hosts (requires root access and reachability)"
	@echo "  deploy-<hostname>  - Deploy to a specific NixOS host (e.g., deploy-north)"
	@echo "  deploy-rukako      - Deploy to rukako at its specific IP"
	@echo "  deploy-darwin      - Deploy to all Darwin hosts"
	@echo "  deploy-macbook     - Deploy to the local macbook"
	@echo ""
	@echo "  proxmox-lxc        - Build the Proxmox LXC template"
	@echo ""
	@echo "  help               - Show this help message"

.DEFAULT_GOAL := help
