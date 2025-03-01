{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pydantic
, pythonOlder
, requests
, tenacity
}:

buildPythonPackage rec {
  pname = "langchainplus-sdk";
  version = "0.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "langchainplus_sdk";
    hash = "sha256-yRGpj9LQK6pI90K31wD9alXxHJpUXuXWawiCWUDJoy4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pydantic
    requests
    tenacity
  ];

  # upstrem has no tests
  doCheck = false;

  pythonImportsCheck = [
    "langchainplus_sdk"
  ];

  meta = {
    description = "Client library to connect to the LangChainPlus LLM Tracing and Evaluation Platform";
    homepage = "https://pypi.org/project/langchainplus-sdk/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
