{
  perSystem = { config, pkgs, ... }:
    let
      terraform = pkgs.opentofu;
    in
    {
      treefmt.config = {
        programs = {
          terraform = {
            package = terraform;
            enable = true;
          };
        };
      };
      devshells.default = {
        packages = [ terraform ];
      };
    };
}
