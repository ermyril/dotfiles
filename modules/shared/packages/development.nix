{ pkgs, ... }:

{
  # Development tools that should be available system-wide
  environment.systemPackages = with pkgs; [
    # Build tools
    cmake
    clang
    
    # Version control
    git
    
    # Text processing
    ripgrep
    
    # Formatters
    nixfmt-classic
    
    # Language servers and tools
    gopls
    
    gh

    # LLM tools
    claude-code
    gemini-cli
    aider-chat-full

  ];
}

