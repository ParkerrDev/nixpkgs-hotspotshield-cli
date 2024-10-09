with import <nixpkgs> {};

let
  version = "1.0.7";
  src = fetchurl {
    url = "https://repo.hotspotshield.com/deb/rel/all/pool/main/h/hotspotshield/hotspotshield_${version}_amd64.deb";
    sha256 = "0z3jzv7flkiighcxcwfmxnwsb772hz3khjswqxav86c7bix9lnbf";
  };
in
stdenv.mkDerivation {
  name = "hotspotshield-${version}";
  buildInputs = [ dpkg patchelf libnl ];

  src = src;

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out

    # Clean up unnecessary directories
    rm -rf $out/etc

    # Create a symlink
    mkdir -p $out/bin
    ln -s $out/usr/bin/hotspotshield $out/bin/hotspotshield

    # Ensure the lib directory exists if needed
    if [ -d $out/usr/lib/x86_64-linux-gnu ]; then
      patchelf --set-rpath $out/usr/lib/x86_64-linux-gnu:$NIX_LDFLAGS $out/usr/bin/hotspotshield
    else
      echo "Warning: lib directory does not exist, skipping patchelf"
    fi

    # Copy libnl libraries to the output lib directory
    mkdir -p $out/lib
    cp -r ${lib.makeLibraryPath [ libnl ]}/* $out/lib/

    # Ensure libhssvpn.so is in the correct location
    if [ -f $out/usr/lib/libhssvpn.so ]; then
      cp $out/usr/lib/libhssvpn.so $out/lib/
    else
      echo "Warning: libhssvpn.so not found"
    fi
  '';

  shellHook = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib.makeLibraryPath [ libnl ]}:$out/lib
  '';

  meta = with lib; {
    description = "Hotspot Shield VPN";
    license = licenses.free;
    platforms = platforms.linux;
  };
}