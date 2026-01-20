{ config, pkgs, ... }:


{
  systemd.services.my-backup = {
    script = ''
      echo "Running backup script..."
      # /run/current-system/sw/bin/rsync ...
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers.my-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";      # Run once a day (midnight)
      Persistent = true;         # <--- THE KEY SETTING
      Unit = "my-backup.service";
    };
  };

}
