# secrets.nix
let
  user = "age1djhtz2rgz438cxqngfs59mzawduf0tvfftha76yt6vzez4m5husq9dhnkc";
  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+g00nzIZs9iKpyG8Y4Yzl0iW3CSdpFC9RaA2RUYATc"
  ];
in
{
  "secrets/test.age".publicKeys = [ user ] ++ systems;  # Include the full path
}

