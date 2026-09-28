{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "user";
        email = "change-me@example.com";
      };
    };
  };
}
