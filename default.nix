let

  fetchTarballFromGitHub =
    { owner, repo, rev, sha256, ... }:
    builtins.fetchTarball {
      url = "https://github.com/${owner}/${repo}/tarball/${rev}";
      inherit sha256;
    };

  fromJSONFile = f: builtins.fromJSON (builtins.readFile f);

in

{ nixpkgs ? fetchTarballFromGitHub (fromJSONFile ./nixpkgs-src.json) }:

with import nixpkgs {
  overlays = [
    (self: super: {
      latex = super.texlive.combine {
        inherit (super.texlive) scheme-basic
          crop
          etoolbox
          flowfram
          latexmk
          xfor
          xkeyval;
      };
    })
  ];
};

stdenv.mkDerivation rec {
  name = "latex-comic-playgroud-${version}-env";
  version = builtins.readFile ./VERSION;
  src = ./.;

  # FONTCONFIG_FILE = makeFontsConf {
  #   fontDirectories = [
  #   ];
  # };

  buildInputs = [
    latex
  ];

  meta = with stdenv.lib; {
    description = "Can I make comics with LaTeX?";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.unix;
  };
}
