# flake.nix — pi agent config
# nix run .          → sandboxed
# nix profile install → permanent (symlinks ~/.pi/agent/*)
{
  description = "pi agent config: settings + keybindings + skills + themes + prompts";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in {
      packages = forAllSystems (pkgs: let
        config = pkgs.stdenv.mkDerivation {
          name = "pi-moss-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp settings.json keybindings.json AGENTS.md $out/
            cp -r skills themes prompts $out/
          '';
        };
      in {
        inherit config;
        default = pkgs.writeShellScriptBin "pi-config" ''
          PI=~/.pi/agent
          if echo "$0" | grep -q "/nix/var/nix/profiles/"; then
            mkdir -p $PI/skills $PI/themes $PI/prompts
            for f in settings.json keybindings.json AGENTS.md; do
              rm -f $PI/$f
              ln -sf ${config}/$f $PI/$f
            done
            rm -rf $PI/skills/* $PI/themes/* $PI/prompts/*
            for d in skills themes prompts; do
              for f in ${config}/$d/*; do
                name=$(basename "$f")
                ln -sfn "$f" "$PI/$d/$name"
              done
            done
            echo "🌿 pi config → $PI"
          else
            DIR=$(mktemp -d); trap 'rm -rf $DIR' EXIT
            mkdir -p $DIR/agent
            ln -sfn ${config} $DIR/agent/pi-config
            echo "pi config at $DIR/agent (sandboxed)"
          fi
        '';
      });
    };
}
