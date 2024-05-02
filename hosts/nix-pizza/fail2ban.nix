{
  services.fail2ban = {
    enable = true;
    maxretry = 10;
  };

  # TODO should we persist the fail2ban database?
}
