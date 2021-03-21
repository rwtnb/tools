{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    libyaml
    luajit
    luajitPackages.luarocks
  ];

  shellHook=''
    YAML_DIR=${pkgs.libyaml} luarocks build
  '';
}
