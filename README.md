# MTKClient-NixOS-Live-Boot
This project is to create a reproducible and easily configureable Live Boot enviroment to use MTKClient.

The live environment is built without sound and with xfce. The password for the provided user "mtkclient" is 1234.

The code shared here is to build an ISO using a NixOS bootable ISO as the base. This base is used in the NixOS installer but can be used for alternative means such as this.

To build the Arm ISO from an x86_64 NixOS install you will need to add this to your configuration:
```
nix.settings.extra-platforms = [ "aarch64-linux" ];
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
```
Within the configuration consider changing the iso compression for a faster build time. See the notes in the configuration file.

Refer to the nixpkgs ISO templates to see what they already add, and potential options to consider.
For this template we are using the base ISO, which can be found here: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/cd-dvd/iso-image.nix

Also refer to the NixOS manual page for building images: https://nixos.org/manual/nixos/stable/index.html#sec-building-image

To build for x86_64:
```
sudo nixos-rebuild build-image --image-variant iso --flake .#mtkclient_x86_64
```
To build for aarch64:
```
sudo nixos-rebuild build-image --image-variant iso --flake .#mtkclient_aarch64
```

Built images may be found here: https://drive.proton.me/urls/DKTPCA86QR#g7CKnFBF6K4i
