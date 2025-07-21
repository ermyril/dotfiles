## Nix Flakes

- When working with flakes you need to be sure that when you adding or moving files - they need to be in the git index, so don't forget to add them before trying to run builds or tests

## Home Manager

- When performing modifications to the home-manager configuration - be sure to implement changes so that they'll be applied for all hosts

## Configuration Philosophy

- We should aim for a modular configuration, when setting up a single module - we should include adjacent programs, dependencies, and configuration - regarding this module, including code which enables module itself. So that our aim is to be able to enable comprehensive configuration by only including or excluding a module