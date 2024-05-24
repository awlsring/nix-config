{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "awlsring";
    userEmail = "contact@matthewrawlings.com";
  };
}
