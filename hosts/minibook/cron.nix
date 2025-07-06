{ config, lib, pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 */24 * * *      root    nix-channel --update"
    ];
  };
}
