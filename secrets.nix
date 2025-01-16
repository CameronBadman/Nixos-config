let
  cameron = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnKPSy04/etB5lEfE5Eh3OWBjKc+84QUo8WNm33oJY6 agenix";
  users = [ cameron ];
in
{
  "wifi.age".publicKeys = users;
}
