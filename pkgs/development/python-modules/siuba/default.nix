{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, hypothesis
, numpy
, pandas
, psycopg2
, pymysql
, python-dateutil
, pytz
, pyyaml
, six
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "siuba";
  version = "0.4.4";
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "machow";
    repo = "siuba";
    rev = "refs/tags/v${version}";
    hash = "sha256-rd/yQH3sbZqQAQ1AN44vChe30GMJuIlZj3Ccfv1m3lU=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    psycopg2
    pymysql
    python-dateutil
    pytz
    pyyaml
    six
    sqlalchemy
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];
  doCheck = false;
  # requires running mysql and postgres instances; see docker-compose.yml

  pythonImportsCheck = [
    "siuba"
    "siuba.data"
  ];

  meta = with lib; {
    description = "Use dplyr-like syntax with pandas and SQL";
    homepage = "https://siuba.org";
    changelog = "https://github.com/machow/siuba/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
