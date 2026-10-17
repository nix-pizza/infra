{
  imports = [
    ./module.nix
  ];

  # Attribute names are GitHub usernames when `githubRole` is set.
  # `terraform = true` keys are uploaded to Hetzner and used for the initial
  # bootstrap of the server; root access is configured in hosts/default.nix.
  infra.sshKeys = {
    aciceri = {
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzCmDCtlGscpesHuoiruVWD2IjYEFtaIl9Y2JZGiOAyf3V17KPx0MikcknfmxSHi399SxppiaXQHxo/1wjGxXkXNTTv6h1fBuqwhJE6C8+ZSV+gal81vEnXX+/9w2FQqtVgnG2/mO7oJ0e3FY+6kFpOsGEhYexoGt/UxIpAZoqIN+CWNhJIASUkneaZWtgwiL8Afb59kJQ2E7WbBu+PjYZ/s5lhPobhlkz6s8rkhItvYdiSHT0DPDKvp1oEbxsxd4E4cjJFbahyS8b089NJd9gF5gs0b74H/2lUUymnl63cV37Mp4iXB4rtE69MbjqsGEBKTPumLualmc8pOGBHqWIdhAqGdZQeBajcb6VK0E3hcU0wBB+GJgm7KUzlAHGdC3azY0KlHMrLaZN0pBrgCVR6zBNWtZz2B2qMBZ8Cw+K4vut8GuspdXZscID10U578GxQvJAB9CdxNUtrzSmKX2UtZPB1udWjjIAlejzba4MG73uXgQEdv0NcuHNwaLuCWxTUT5QQF18IwlJ23Mg8aPK8ojUW5A+kGHAu9wtgZVcX1nS5cmYKSgLzcP1LA1l9fTJ1vqBSuy38GTdUzfzz7AbnkRfGPj2ALDgyx17Rc5ommjc1k0gFoeIqiLaxEs5FzDcRyo7YvZXPsGeIqNCYwQWw3+U+yUEJby8bxGb2d/6YQ==";
      terraform = true;
      githubRole = "admin";
    };
    # Second key of aciceri, not used for Terraform
    aciceri-pike = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm9Sl/I+5G4g4f6iE4oCUJteP58v+wMIew9ZuLB+Gea";
    };
    zarelit = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFp38ldUYwFQ9JlZ4CTBWWM6S9OmY7yhJSHyMXSASZB";
      terraform = true;
      githubRole = "admin";
    };
    albertodvp = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcH6SFgp2hFog79YE0T3eft/Fq3gciYJi+msTCgZMtO";
      githubRole = "admin";
    };
    TonioGela = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWwmMYuP1GUPSBRiven+ia4YQhwoNXNyjw6OOTYL/Md";
      githubRole = "admin";
    };
    # Automation account: owner of the GitHub PAT used by the github provider
    ambrogio-bot = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtnZ3DbWbrDAMJ9lmy/8Ny6DHNNTk31ec9X3wEXkj/9";
      githubRole = "admin";
    };
    akiross = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAS0g7ekYGKMH9S4StWw8FrYnedXWs3K5oJqz/wWhTA7";
      githubRole = "member";
    };
    aleclearmind = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhlTg5Wo0wXsep+nwAIU1l6Ul6YGgGjhQv+phaM3JOw";
      githubRole = "member";
    };
    amerocu = {
      githubRole = "member";
    };
    c3n21 = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEe8GWE28Ay4ZWLGVbCFZ9P+gC/bavqdemUbYcUlrpkI";
      githubRole = "member";
    };
    lorenzoajo = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgOYV6YQEFISO0ZJDfhrI0OZxz8JoILF+Dae/OLZAgn";
      githubRole = "member";
    };
    rokkian = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRdYvoJqwEcpsfq10mgSH3ymX2PIfP6fOuec5Xij5bi";
      githubRole = "member";
    };
    scalvotux = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBdl0Nx96418CL0Jvp/1Ok/PksbOTA1gybwvDg0xITvu";
      githubRole = "member";
    };
    slavni96 = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMILswedl3IPcXPpg5MDne22NzN8UOH7Z5tvnAre7rN";
      githubRole = "member";
    };
    x71c9 = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/G1LP03z6nRtBNxHLZYkOrQeb53Nf4w3np5tNoNo6Y";
      githubRole = "member";
    };
    # CI key (GitHub Actions secret SSH_KEY)
    github = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/QCcDbHe8u7oczv2djwDb4S7SC+rasbGiVl2IW5585";
      terraform = true;
    };
    nix-pizza = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3+B5N13uj6kGwWQZyiNYAwVQpxg5l/GjrKLKGoZLpn";
    };
  };
}
