{config, lib, pkgs}


# these files are for specific hardware requirementes needed for specific setups 
{
import = [
    ./nvidia/
];
}
