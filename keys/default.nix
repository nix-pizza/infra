{
  imports = [
    ./module.nix
  ];

  infra.sshKeys = {
    aciceri = {
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzCmDCtlGscpesHuoiruVWD2IjYEFtaIl9Y2JZGiOAyf3V17KPx0MikcknfmxSHi399SxppiaXQHxo/1wjGxXkXNTTv6h1fBuqwhJE6C8+ZSV+gal81vEnXX+/9w2FQqtVgnG2/mO7oJ0e3FY+6kFpOsGEhYexoGt/UxIpAZoqIN+CWNhJIASUkneaZWtgwiL8Afb59kJQ2E7WbBu+PjYZ/s5lhPobhlkz6s8rkhItvYdiSHT0DPDKvp1oEbxsxd4E4cjJFbahyS8b089NJd9gF5gs0b74H/2lUUymnl63cV37Mp4iXB4rtE69MbjqsGEBKTPumLualmc8pOGBHqWIdhAqGdZQeBajcb6VK0E3hcU0wBB+GJgm7KUzlAHGdC3azY0KlHMrLaZN0pBrgCVR6zBNWtZz2B2qMBZ8Cw+K4vut8GuspdXZscID10U578GxQvJAB9CdxNUtrzSmKX2UtZPB1udWjjIAlejzba4MG73uXgQEdv0NcuHNwaLuCWxTUT5QQF18IwlJ23Mg8aPK8ojUW5A+kGHAu9wtgZVcX1nS5cmYKSgLzcP1LA1l9fTJ1vqBSuy38GTdUzfzz7AbnkRfGPj2ALDgyx17Rc5ommjc1k0gFoeIqiLaxEs5FzDcRyo7YvZXPsGeIqNCYwQWw3+U+yUEJby8bxGb2d/6YQ==";
      terraform = true;
    };
    zarelit = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFp38ldUYwFQ9JlZ4CTBWWM6S9OmY7yhJSHyMXSASZB";
      terraform = true;
    };
    github = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/QCcDbHe8u7oczv2djwDb4S7SC+rasbGiVl2IW5585";
      terraform = true;
    };
    nix-pizza = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3+B5N13uj6kGwWQZyiNYAwVQpxg5l/GjrKLKGoZLpn";
      terraform = false;
    };
  };
}
