{ lib, stdenv }:

stdenv.mkDerivation {
  pname = "mac-os-9-platinum";
  version = "1.0";

  src = ../../modules/home/xfce/themes/Mac-OS-9-Platinum-Default;

  installPhase = ''
    mkdir -p $out/share/themes/Mac-OS-9-Platinum
    cp -r * $out/share/themes/Mac-OS-9-Platinum/
  '';

  meta = with lib; {
    description = "Mac OS 9 Classic theme for GTK2/3";
    homepage = "https://github.com/B00merang-Project/Mac-OS-9";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
