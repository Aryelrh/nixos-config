{ lib, buildGoModule, fetchFromGitHub, pkg-config, libogg, libvorbis, flac, alsa-lib }:

let
  go-librespot = buildGoModule {
    pname = "lazyspotify-librespot";
    version = "unstable";

    src = fetchFromGitHub {
      owner = "devgianlu";
      repo = "go-librespot";
      rev = "3dfea663af198ded4ad255778043f911f6fc157e";
      hash = "sha256-JcVQFqS9fhtXzUbd7jn5OxBVOlgmPPsg+huZlKZ45qg=";
    };

    vendorHash = "sha256-kCzzybOEP4Tp7OGFZBjIP1FgcQ9u+lgO3931gbaG9hA=";

    subPackages = [ "cmd/daemon" ];

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libogg libvorbis flac alsa-lib ];
  };

in buildGoModule {
  pname = "lazyspotify";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "dubeyKartikay";
    repo = "lazyspotify";
    rev = "b77fea1d34d06292001180cc3f350f120378ae7e";
    hash = "sha256-UwwXG8Ps2M3iB1QtENf9l1kjbssKlaJr7//u96GzdcU=";
  };

  vendorHash = "sha256-Axdt3/3ZOZY9Z5VUI6Wh77oIREOO26ODMyEgtscTmn8=";

  subPackages = [ "cmd/lazyspotify" ];

  ldflags = [
    "-X github.com/dubeyKartikay/lazyspotify/buildinfo.PackagedDaemonPath=${go-librespot}/bin/daemon"
  ];
}
