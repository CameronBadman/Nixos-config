{ config, lib, ... }:
{
  age.secrets.test = {
    file = lib.cleanSource ../secrets/test.age;
    owner = "cameron";
    group = "users";
    mode = "400";
  };
}
