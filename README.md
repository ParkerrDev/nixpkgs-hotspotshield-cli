# nixpkgs-hotspotshield-cli
Hotspotshield-cli for NixOS

This is not a fully implemented nixpkg.

I started to package the hotspotshield_1.0.7_amd64.deb for NixOS and got it working for the most part until I realize that the hotspotshield-cli is for premium hotspotshield accounts only. All that hard work for nothing. But here you go anyways:

Heres how I got it working:

`git clone https://github.com/ParkerrDev/nixpkgs-hotspotshield-cli.git`

`cd nixpkgs-hotspotshield-cli`

`nix build`

`env LD_LIBRARY_PATH=./result/lib steam-run ./result/bin/hotspotshield`
