{ stdenv
, lib
, fetchFromGitHub
, buildGo120Package
}:

buildGo120Package rec {
  pname = "ssm-session-manager-plugin";
  version = "1.2.463.0";

  goPackagePath = "github.com/aws/session-manager-plugin";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "session-manager-plugin";
    rev = version;
    sha256 = "sha256-0n7/3CAPf+ioSE041Zik9xeHt5qtrdHotJjBWhizExo=";
  };

  postPatch = ''
    mv vendor{,-old}
    mv vendor-old/src vendor
    rm -r vendor-old
  '';

  preBuild = ''
    pushd go/src/${lib.escapeShellArg goPackagePath}
    echo -n ${lib.escapeShellArg version} > VERSION
    go run src/version/versiongenerator/version-gen.go
    popd
  '';

  doCheck = true;
  checkFlags = [ "-skip=TestSetSessionHandlers" ];

  preCheck = ''
    if ! [[ $(go/bin/sessionmanagerplugin-main --version) = ${lib.escapeShellArg version} ]]; then
      echo 'wrong version'
      exit 1
    fi
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 go/bin/sessionmanagerplugin-main "$out/bin/session-manager-plugin"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    license = licenses.asl20;
    maintainers = with maintainers; [ amarshall mbaillie ];
  };
}
