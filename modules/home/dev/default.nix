{ username, ... }: {
  imports = [
    (
      if username == "awlsring" then ./personal.nix
      else if username == "rawmatth" then ./work.nix
      else {}
    )
  ];
}
