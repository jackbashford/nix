{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.j;
in
{

  options = {
    j.dev.dafny = lib.mkEnableOption "Add Dafny language support";
  };
  config = lib.mkIf cfg.dev.dafny {
    nixpkgs.overlays = [
      (final: prev: {
        dafny = prev.dafny.overrideAttrs (oldAttrs: {
          postPatch =
            let
              runtimeJarVersion = "4.10.0";
            in
            ''
              echo blobfish
              cp ${pkgs.writeScript "fake-gradlew-for-dafny" ''
                mkdir -p build/libs/
                javac $(find -name "*.java" | grep "^./src/main") -d classes
                file build/libs/DafnyRuntime-${runtimeJarVersion}.jar
                jar cf build/libs/DafnyRuntime-${runtimeJarVersion}.jar -C classes dafny
              ''} Source/DafnyRuntime/DafnyRuntimeJava/gradlew

              # Needed to fix
              # "error NETSDK1129: The 'Publish' target is not supported without
              # specifying a target framework. The current project targets multiple
              # frameworks, you must specify the framework for the published
              # application."
              substituteInPlace Source/DafnyRuntime/DafnyRuntime.csproj \
                --replace-fail TargetFrameworks TargetFramework \
                --replace-fail "netstandard2.0;net452" net8.0

              substituteInPlace Source/DafnyLanguageServer/DafnyLanguageServer.cs \
                --replace "DafnyVersion)" "new[] { DafnyVersion })"
            '';
        });
      })
    ];
    home.packages = [
      pkgs.dotnetCorePackages.dotnet_9.sdk
      pkgs.dafny
    ];

    programs.helix.languages = lib.mkIf cfg.helix.enable {
      language-server.dafny = {
        command = "${pkgs.dafny}/bin/dafny";
        args = [
          "server"
          "--verify-on:Change"
          "--verification-time-limit:20"
          "--cache-verification=0"
          "--cores:9"
          "--notify-ghostness:true"
          "--notify-line-verification-status:true"
          "--verifier:gutterStatus=true"
        ];
      };
      language = [
        {
          name = "dafny";
          scope = "source.dafny";
          file-types = [
            "dfy"
          ];
          indent = {
            tab-width = 4;
            unit = "    ";
          };
          language-servers = [
            "dafny"
          ];
        }
      ];

      grammar = [
        {
          name = "dafny";
          source.path = "/home/jack/Code/Projects/tree-sitter-dafny";
        }
      ];
    };
  };
}
