{
  inputs = {
    damper = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:wrsturgeon/damper-pytorch";
    };
    deepobs = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:wrsturgeon/deepobs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      damper,
      deepobs,
      flake-utils,
      nixpkgs,
      self,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pname = "damper-deepobs";
        version = "0.1.0";
        src = ./.;
        python-version = "312";
        pkgs = import nixpkgs {
          inherit system;
          config.allowBroken = true;
        };
        pypkgs = pkgs."python${python-version}Packages";
        dependencies =
          pypkgs:
          (builtins.map (f: f.lib.with-pkgs pkgs pypkgs) [
            damper
            deepobs
          ])
          ++ (with pypkgs; [
            bayesian-optimization
            torchvision
          ]);
        python = pypkgs.python;
      in
      {
        apps = builtins.mapAttrs (k: v: {
          type = "app";
          program = "${
            pkgs.stdenv.mkDerivation {
              pname = "run";
              version = "ad-hoc";
              inherit src;
              buildPhase = ":";
              installPhase = ''
                mkdir -p $out/bin
                echo '#!{pkgs.bash}/bin/bash' > $out/bin/run
                echo '${v}' >> $out/bin/run
                chmod +x $out/bin/run
                wrapProgram $out/bin/run --prefix PATH : ${
                  nixpkgs.lib.makeBinPath ([ python ] ++ (with pkgs; [ wget ]))
                }
              '';
              nativeBuildInputs = with pkgs; [ makeWrapper ];
            }
          }/bin/run";
        }) { };
        devShells.default = pkgs.mkShell {
          packages = [
            python
            pypkgs.python-lsp-server
          ] ++ (dependencies pypkgs);
        };
      }
    );
}
