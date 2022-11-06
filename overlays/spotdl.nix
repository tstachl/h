{ final, prev, ... }:
let
  app = final.fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v4.0.1";
    sha256 = "sha256-Rov5oCAhSWb57tfaA9fzavk0hwsF8bkuL6yoFvHp0Cw=";
  };
in
final.poetry2nix.mkPoetryApplication rec {
  projectDir = app;
  src = app;
  python = final.python39;

  overrides = final.poetry2nix.overrides.withDefaults (self: super: {
    altgraph = super.altgraph.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.setuptools ];
    });

    scikit-build = super.scikit-build.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ final.cmake ];
    });

    pyinstaller-hooks-contrib = super.pyinstaller-hooks-contrib.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.setuptools ];
    });

    pyinstaller = super.pyinstaller.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ final.zlib python.pkgs.setuptools ];
    });

    types-ujson = super.types-ujson.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.setuptools ];
    });

    types-orjson = super.types-orjson.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.setuptools ];
    });

    types-python-slugify = super.types-python-slugify.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.setuptools ];
    });

    toml = super.toml.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [  ];
    });

    packaging = super.packaging.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [  ];
    });

    poetry = super.poetry.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [  ];
    });

    importlib-metadata = super.importlib-metadata.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [  ];
    });

    flit-core = super.flit-core.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [  ];
    });

    flit-scm = super.flit-scm.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ self.flit-core ];
    });

    exceptiongroup = super.exceptiongroup.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ self.flit-scm ];
    });

    pytest = super.pytest.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ self.flit-core ];
    });

    mdformat-tables = super.mdformat-tables.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ self.flit-core ];
    });

    mdformat-gfm = super.mdformat-gfm.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ self.flit-core self.poetry ];
    });

    mkdocs-material-extensions = super.mkdocs-material-extensions.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.hatchling ];
    });

    mkdocstrings-python = super.mkdocstrings-python.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.pdm-pep517 ];
    });

    mkdocs-material = super.mkdocs-material.overridePythonAttrs (old: {
      version = "8.5.2";
      src = super.fetchPypi {
        pname = "mkdocs-material";
        version = "8.5.2";
        sha256 = "sha256-FsoTBKk7CF5d+w28xoG3Ta0Vh9i6cnyJyP1CWd2P4AQ=";
      };
      buildInputs = old.buildInputs or [ ] ++ [ ];
    });

    mkdocs = super.mkdocs.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.babel ];
    });

    mkdocs-section-index = super.mkdocs-section-index.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ self.poetry ];
    });

    dulwich = super.dulwich.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ python.pkgs.pygpgme ];
    });

    pydantic = super.pydantic.overridePythonAttrs (old: {
      buildInputs = old.buildInnputs or [ ] ++ [ final.libxcrypt ];
    });

    rapidfuzz = super.rapidfuzz.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ self.packaging self.scikit-build ];
    });
  });
}
