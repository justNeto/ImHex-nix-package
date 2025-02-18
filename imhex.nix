{
    lib,
    fetchFromGitHub,
    cmake,
    ccache,
    curl,
    dbus,
    dotnet-runtime,
    fontconfig,
    freetype,
    gcc14,
    glfw,
    glm,
    gtk3,
    lz4,
    libgcc,
    mbedtls,
    ninja,
    pkg-config,
    stdenv,
    wayland-utils,
    wayland-scanner,
    xz,
    zstd,
    zlib
}:

stdenv.mkDerivation {
    pname = "ImHex";
    version = "1.37.0";
    phases = [ "configPhase" "buildPhase" "installPhase" ];

    src = fetchFromGitHub {
        owner = "WerWolv";
        repo = "ImHex";
        hash = "sha256-Hh9Ghtt5YYK7+6bxbNCBiulaeJqdx9g9DergPJz/Ncw=";
        rev = "658d4c4";
        fetchSubmodules = true;
    };

    imhex_patterns_SOURCE_DIR = fetchFromGitHub {
        owner = "WerWolv";
        repo = "ImHex-Patterns";
        hash = "sha256-2NgMYaG6+XKp0fIHAn3vAcoXXa3EF4HV01nI+t1IL1U=";
        rev = "375145e";
    };

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
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
        dotnet-runtime
    ];

    # Set the build environment
    configPhase = ''
        runHook preConfigure

        export CC=${gcc14}/bin/gcc
        export CXX=${gcc14}/bin/g++
        export BUILD_DIR=$(mktemp -d)

        runHook postConfigure
    '';

    buildPhase = ''
        runHook preBuild

        cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -S $src -B $BUILD_DIR -D IMHEX_OFFLINE_BUILD=ON

        run postBuild
    '';

    installPhase = ''
        runHook preInstall

        ninja -C $BUILD_DIR install
        mv $BUILD_DIR/imhex $out

        runHook postInstall
    '';

    meta = with lib; {
        description = "ImHex: A Hex Editor";
        license = licenses.mit;
        platforms = platforms.linux;
        maintainers = with maintainers; [ justNeto ];
    };
}
