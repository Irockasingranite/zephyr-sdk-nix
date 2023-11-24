{
    description = "The Zepyhr SDK";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs";

        zephyr-sdk-src-0-15-2 = {
            type = "tarball";
            url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.2/zephyr-sdk-0.15.2_linux-x86_64.tar.gz";
            flake = false;
        };

        zephyr-sdk-src-0-16-0-beta1 = {
            type = "tarball";
            url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.0-beta1/zephyr-sdk-0.16.0-beta1_linux-x86_64.tar.xz";
            flake = false;
        };

        zephyr-sdk-src-0-16-0-rc1 = {
            type = "tarball";
            url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.0-rc1/zephyr-sdk-0.16.0-rc1_linux-x86_64.tar.xz";
            flake = false;
        };

        zephyr-sdk-src-0-16-1 = {
            type = "tarball";
            url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.1/zephyr-sdk-0.16.1_linux-x86_64.tar.xz";
            flake = false;
        };

        zephyr-sdk-src-0-16-3 = {
            type = "tarball";
            url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.3/zephyr-sdk-0.16.3_linux-x86_64.tar.xz";
            flake = false;
        };
    };

    outputs = { self, nixpkgs,
                zephyr-sdk-src-0-15-2,
                zephyr-sdk-src-0-16-0-beta1,
                zephyr-sdk-src-0-16-0-rc1,
                zephyr-sdk-src-0-16-1,
                zephyr-sdk-src-0-16-3 }:

        let pkgs = import nixpkgs {
                system = "x86_64-linux";
            };
            sdk-derivation = { pkgs, src, name }: pkgs.stdenv.mkDerivation {
                inherit name;
                inherit src;
                nativeBuildInputs = with pkgs; [ cmake which wget autoPatchelfHook ];

                # Without these the included binaries won't run in a nix
                # environment, i.e. during a nix build or on nixOS
                buildInputs = with pkgs; [
                    stdenv.cc.cc.lib
                    python38
                ];

                dontUseCmakeConfigure = true;
                dontBuild = true;

                installPhase = ''
                    mkdir -p $out
                    mv ./* $out
                    cd $out
                    bash setup.sh -t all
                '';
            };
        in rec {
            packages.x86_64-linux.zephyr-sdk-latest = packages.x86_64-linux.zephyr-sdk-0-16-3;
            packages.x86_64-linux.zephyr-sdk-0-16-3 = sdk-derivation { inherit pkgs; src = zephyr-sdk-src-0-16-3; name = "Zephyr SDK v0.16.3"; };
            packages.x86_64-linux.zephyr-sdk-0-16-beta1 = sdk-derivation { inherit pkgs; src = zephyr-sdk-src-0-16-0-beta1; name = "Zephyr SDK v0.16.0-beta1"; };
            packages.x86_64-linux.zephyr-sdk-0-16-rc1 = sdk-derivation { inherit pkgs; src = zephyr-sdk-src-0-16-0-rc1; name = "Zephyr SDK v0.16.0-rc1"; };
            packages.x86_64-linux.zephyr-sdk-0-16-1 = sdk-derivation { inherit pkgs; src = zephyr-sdk-src-0-16-1; name = "Zephyr SDK v0.16.1"; };
            packages.x86_64-linux.zephyr-sdk-0-15-2 = sdk-derivation { inherit pkgs; src = zephyr-sdk-src-0-15-2; name = "Zephyr SDK v0.15.2"; };
        };
}
