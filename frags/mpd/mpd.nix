{ config, lib, pkgs, ... }:
{
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pulse"
        name "PulseAudio a.k.a. PipeWire (tm)"
        server "127.0.0.1"
      }
    '';
  };
  
  # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
  # mpd must run as pipewire user
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.fred.uid}";
  };
  
}
