{
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

            CC="gcc";
            CXX="g++";
            CMAKE_INSTALL_PREFIX = "$out";
            dbus = pkgs.dbus;
        };
    };
}
