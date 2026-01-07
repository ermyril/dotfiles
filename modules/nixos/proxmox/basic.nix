{ pkgs, ... }:

{
  time.timeZone = "Europe/Prague";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwXgfYFJlkEF8NBTfURNKyNiK5vatysNFV9kzud+LaP7tZt2W59qalr/1kSa91WmBpzTYi/Fgxw3z9lpRW0CP9WV25bJr9bHMYNZ0f5r2cidCxEeyJ5p0Z91aaX+HyEyowWG58s6uxL5d2Gh3nmPW8rPpSOfXSsgvYSEOTEv6RqKt73UrQr7ReCcTXGfwxa0qcTFYnIOSOsq4N7PlCkVZVjEfH1VEhzAKUA0uKqyUGwPNd0IQF7AaqZdwVN07xQohOtza0kxZfBPzSjLzK5zB9+JLKfYWpeS7sNdUslh/sEIAXCJBFTIi9Vz81tBSC+5SG7lUJUORy8JEs/6C1KB37Q=="
  ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    vim
  ];

  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "soft"; value = "65536"; }
    { domain = "*"; item = "nofile"; type = "hard"; value = "65536"; }
    { domain = "*"; item = "nproc";  type = "soft"; value = "30000"; }
    { domain = "*"; item = "nproc";  type = "hard"; value = "30000"; }
  ];
}
