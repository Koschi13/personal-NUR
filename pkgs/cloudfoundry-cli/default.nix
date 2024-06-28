{ lib
, buildGoModule
, fetchFromGitHub
, fetchurl
, installShellFiles
,
}:

buildGoModule rec {
  pname = "cloudfoundry-cli";
  version = "7.7.10";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-9DN5dvp2WCuE5jUJAcgHns+an9RrrqsBdzFQXNOe0Co=";
  };
  vendorHash = "sha256-60aE9EOzlTd21roMNuJkkoq3G5lxQI4SM8twFlflpdM=";

  subPackages = [ "." ];

  bashCompletionScript = fetchurl {
    url = "https://raw.githubusercontent.com/cloudfoundry/cli-ci/7f253f00b18907571ab18f16476d5431f8ddea3a/ci/installers/completion/cf8";
    sha256 = "7ee78e471d6924b81e9062083e1ad13be2b18e70135a7cc9da9b75f5984c0fee";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X code.cloudfoundry.org/cli/version.binaryBuildDate=1970-01-01"
    "-X code.cloudfoundry.org/cli/version.binaryVersion=${version}"
  ];

  postInstall = ''
    mv "$out/bin/cli" "$out/bin/cf"
    installShellCompletion --bash $bashCompletionScript
  '';

  meta = with lib; {
    description = "Official command line client for Cloud Foundry";
    homepage = "https://github.com/cloudfoundry/cli";
    maintainers = with maintainers; [ Koschi13 ];
    mainProgram = "cf";
    license = licenses.asl20;
  };
}
