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
    file, #libmagic
    gcc14,
    glfw,
    glm,
    gtk3,
    lz4,
    libgcc,
    mbedtls,
    ninja,
    pkg-config,
    ripgrep,
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
    phases = [ "configurePhase" "buildPhase" "installPhase" ];

    src = fetchFromGitHub {
        owner = "justNeto";
        repo = "ImHex";
        hash = "sha256-Zio2dpmRfwBuU4IccuS2Tzr6zJJUrCmW/d2AyWbBTZU=";
        rev = "8e5fb89";
        fetchSubmodules = true;
    };

    patterns = fetchFromGitHub {
        owner = "WerWolv";
        repo = "ImHex-Patterns";
        hash = "sha256-a2T9sCCxU4t1X4lXrnR3/p2xbedKn2w8SLHtFGIwEYI=";
        rev = "375145e";
        fetchSubmodules = true;
    };

    nativeBuildInputs = [ pkg-config ripgrep ];

    buildInputs = [
        gcc14
        libgcc
        file
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
    configurePhase = ''
        runHook preConfigure

        export CC=${gcc14}/bin/gcc
        export CXX=${gcc14}/bin/g++
        export BUILD_DIR=$(mktemp -d)
        export PATTERNS_DIR=$patterns

        runHook postConfigure
    '';

    buildPhase = ''
        runHook preBuild

        cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -S $src -B $BUILD_DIR -DIMHEX_OFFLINE_BUILD=ON -DIMHEX_ENABLE_EXTERNAL_PATTERNS=ON -DCMAKE_INSTALL_PREFIX=$out

        runHook postBuild
    '';

    installPhase = ''
        runHook preInstall

        ninja -C $BUILD_DIR install

        runHook postInstall
    '';

    meta = with lib; {
        description = "ImHex: A Hex Editor";
        license = licenses.mit;
        platforms = platforms.linux;
        maintainers = with maintainers; [ justNeto WerWolv ];
    };
}
