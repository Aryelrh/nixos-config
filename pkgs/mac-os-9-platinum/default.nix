{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "mac-os-9-platinum";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "moltensoftware";
    repo = "Mac-OS-9-Classic-XFCEfixes";
    rev = "f6a3f517e7bfbb30dcd61ecb2227390fd9276901";
    sha256 = "1nwqz6hp07mkaxpfrmdc535lv9x3bmws13df58c89n7qnqz1pchz";
  };

  installPhase = ''
    mkdir -p $out/share/themes/Mac-OS-9-Platinum
    cp -r gtk-2.0 gtk-3.0 xfwm4 index.theme $out/share/themes/Mac-OS-9-Platinum/
    rm -f $out/share/themes/Mac-OS-9-Platinum/README.md
  '';

  meta = with lib; {
    description = "Mac OS 9 Platinum theme for GTK2/3 and xfwm4";
    homepage = "https://github.com/moltensoftware/Mac-OS-9-Classic-XFCEfixes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [];
  };
}
