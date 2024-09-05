{
  username,
  pkgs,
  ...
}: {
  # TODO: refactor this to be a module that will create a profile based off username given
  imports = [
    (
      if username == "awlsring"
      then ./personal.nix
      else if username == "rawmatth"
      then ./work.nix
      else {}
    )
  ];

  home.packages = with pkgs; [
    go_1_23
    python313
    nodejs_22
    rustc
    cargo
  ];
}
