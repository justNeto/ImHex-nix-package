{
    # This is a Nix Flake that will produce an output package binary executable accesible via nix develop for now. Later I will try to produce a binary and install it somehow on the system...
    description = "Flake for building imhex properly";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }:
        let
        system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system; };
    in
    {
        devShells.${system}.default = pkgs.mkShell.override { stdenv = pkgs.gcc14Stdenv; } {
            nativeBuildInputs = with pkgs; [
                pkg-config
            ];

            buildInputs = with pkgs; [
                gcc14
                    libgcc
                    gtk3
                    ninja
                    xz
                    mbedtls
                    zstd
                    lz4
                    cmake
                    ccache
                    curl
                    glfw
                    dbus
                    glm
                    fontconfig
                    zlib
                    freetype
                    ocamlPackages.magic
                    ocamlPackages.fontconfig
                    dotnetCorePackages.sdk_9_0-bin
                    ];

            unpackPhase = ''
                git clone https://github.com/WerWolv/ImHex --recurse-submodules
                '';

            configurePhase = ''
                mkdir -p ImHex/build
                echo "TODO: configurePhase"
                '';

            buildPhase = ''
                cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release ImHex ImHex/build;
            cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -S ImHex/ -B ImHex/build;
            ninja -C ImHex/build install;
            echo "TODO: buildPhase";
            '';

            installPhase = ''
                echo "TODO: install!"
                '';

# Defining environment variables to be used at runtime
            CC="gcc";
            CXX="g++";
            CMAKE_INSTALL_PREFIX = "$out";
            dbus = pkgs.dbus;
        };
    };
}
