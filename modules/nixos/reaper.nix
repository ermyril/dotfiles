{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.mySystem.reaper;
in
{
  options.mySystem.reaper = {
    enable = mkEnableOption "Reaper DAW with professional audio production environment";

    enableJackGUI = mkOption {
      type = types.bool;
      default = true;
      description = "Enable qjackctl GUI for JACK management";
    };
  };

  config = mkIf cfg.enable {
    # Enable PipeWire with JACK support for professional audio
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;  # Enable JACK emulation via PipeWire
      alsa.enable = true;

      # Low-latency configuration for pro-audio
      extraConfig.pipewire = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
        };
      };
    };

    # Add primary user to jackaudio group
    users.users.${config.mySystem.primaryUser}.extraGroups = [ "jackaudio" "audio" ];

    # System-wide audio packages
    environment.systemPackages = with pkgs; [
      # Core DAW
      reaper

      # Windows VST bridge for Linux
      yabridge
      yabridgectl

      # JACK tools and utilities
      libjack2
      jack2
      jack_capture
      jack-example-tools  # Provides jack_lsp, jack_connect, etc.

      # JACK GUI utilities (optional, controlled by option)
    ] ++ lib.optionals cfg.enableJackGUI [
      qjackctl
    ];

    # Home-manager configuration for audio production tools
    home-manager.users.${config.mySystem.primaryUser} = {
      home.packages = with pkgs; [
        # Synthesizers and instruments
        vital                # Modern synthesizer
        surge-XT             # Hybrid synthesizer
        geonkick             # Drum synthesizer
        cardinal             # Virtual modular synthesizer (VCV Rack fork)

        # Audio effects plugins
        calf                 # Audio plugin suite (compressors, EQs, reverbs, etc.)
        lsp-plugins          # Linux Studio Plugins (EQs, compressors, etc.)

        # Audio utilities and patchbays
        helvum               # Pipewire patchbay (graphical)
        easyeffects          # Audio effects for PipeWire

        # Audio file manipulation
        flac                 # FLAC codec
        lame                 # MP3 encoder

        # MIDI tools
        qsynth               # Fluidsynth GUI
        fluidsynth           # Software synthesizer
        soundfont-fluid      # General MIDI soundfont

        # Additional audio production tools
        audacity             # Audio editor
        ardour               # Full-featured DAW (alternative/complement to Reaper)
      ];

      # Session variables for VST plugin discovery
      home.sessionVariables = {
        VST_PATH = "$HOME/.vst:$HOME/.local/share/vst:/usr/lib/vst:/usr/local/lib/vst";
        VST3_PATH = "$HOME/.vst3:$HOME/.local/share/vst3:/usr/lib/vst3:/usr/local/lib/vst3";
        LADSPA_PATH = "$HOME/.ladspa:$HOME/.local/share/ladspa:/usr/lib/ladspa:/usr/local/lib/ladspa";
        LV2_PATH = "$HOME/.lv2:$HOME/.local/share/lv2:/usr/lib/lv2:/usr/local/lib/lv2";
        DSSI_PATH = "$HOME/.dssi:$HOME/.local/share/dssi:/usr/lib/dssi:/usr/local/lib/dssi";
      };
    };

    # Set system-wide limits for audio performance
    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];
  };
}
