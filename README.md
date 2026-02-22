# MTKClient-NixOS-Live-Boot
This project is to create a reproducible and easily configureable Live Boot enviroment to use MTKClient.

The live environment is built without sound and with xfce. The password for the provided user "mtkclient" is 1234.

The code shared here is to build an ISO using the NixOS live boot installer as the base.

To build the Arm ISO from an x86_64 NixOS install you will need to add this to your configuration:
```
nix.settings.extra-platforms = [ "aarch64-linux" ];
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
```
Within the configuration consider changing the iso compression for a faster build time.
```
image.modules.iso = {
    isoImage.squashfsCompression = "zstd -Xcompression-level 6";
    # faster
    #isoImage.squashfsCompression = "zstd -Xcompression-level 3";
    # fastest
    #isoImage.squashfsCompression = "lz4";
  };
```

To build for x86_64:
```
sudo nixos-rebuild build-image --image-variant iso --flake .#mtkclient_x86_64
```
To build for aarch64:
```
sudo nixos-rebuild build-image --image-variant iso --flake .#mtkclient_aarch64
```
