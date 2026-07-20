{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "b00merang-windows-7";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "B00merang-Project";
    repo = "Windows-7";
    rev = "943b5307b349d3526068be0fa32f7549ee37ab45";
    sha256 = "0zi4rnrdj5jm2isq21pvb3qqamghxdgxinkxsa3vcyjbzx9hglca";
  };

  installPhase = ''
    mkdir -p $out/share/themes/Windows-7
    cp -r . $out/share/themes/Windows-7/
    rm -f $out/share/themes/Windows-7/README.md $out/share/themes/Windows-7/LICENSE
  '';

  meta = with lib; {
    description = "Windows 7 theme for GTK3/4 and xfwm4";
    homepage = "https://github.com/B00merang-Project/Windows-7";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [];
  };
}
