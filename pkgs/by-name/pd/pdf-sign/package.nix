{ lib
, stdenv
, fetchFromGitHub

, python3
, ghostscript
, pdftk
, poppler_utils
, which
, makeBinaryWrapper
}:

let
  python = python3.withPackages (ps: with ps; [ tkinter ]);
  binPath = lib.makeBinPath [ ghostscript pdftk poppler_utils which ];
in
stdenv.mkDerivation {
  pname = "pdf-sign";
  version = "0-unstable-2024-07-16";

  src = fetchFromGitHub {
    owner = "svenssonaxel";
    repo = "pdf-sign";
    rev = "6c373e3df2ac53af74ea84c3b5f299b13d7dae9c";
    hash = "sha256-yx1ff1JMTydCd5sCIoiT30zRwxNEwFbgEM9++nkJKY4=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ python ];

  installPhase = ''
    runHook preInstall

    sed -ri 's/(^.*argparse\.ArgumentParser.*)\)$/\1, prog="pdf-sign"\)/' pdf-sign
    sed -ri 's/(^.*argparse\.ArgumentParser.*)\)$/\1, prog="pdf-create-empty"\)/' pdf-create-empty
    sed -ri 's/(^.*argparse\.ArgumentParser.*)\)$/\1, prog="pdf-from-text"\)/' pdf-from-text

    install -Dm755 pdf-sign pdf-create-empty pdf-from-text -t $out/bin
    wrapProgram $out/bin/pdf-sign --prefix PATH : ${binPath}
    wrapProgram $out/bin/pdf-create-empty --prefix PATH : ${binPath}
    wrapProgram $out/bin/pdf-from-text --prefix PATH : ${binPath}

    runHook postInstall
  '';

  meta = {
    description = "Tool to visually sign PDF files";
    homepage = "https://github.com/svenssonaxel/pdf-sign";
    license = lib.licenses.mit;
    mainProgram = "pdf-sign";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}

