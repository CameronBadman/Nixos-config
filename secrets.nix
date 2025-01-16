let
  user = "age1wdfy38xsxh6gqz6v5f5n4gctgm85s844wyluqrt5jqavtzcedu9skh7mxm";
  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+g00nzIZs9iKpyG8Y4Yzl0iW3CSdpFC9RaA2RUYATc"
  ];
in
{
  "secrets/test.age".publicKeys = [ user ] ++ systems;  # Match the actual path
}

