![Continuous Integration and Delivery](https://github.com/qr-space/quickdesk-api/workflows/Continuous%20Integration%20and%20Delivery/badge.svg?branch=master)

# SETUP

1. Linux
    > WSL2
    https://learn.microsoft.com/en-us/windows/wsl/install-manual
    https://pureinfotech.com/install-windows-subsystem-linux-2-windows-10/

    > or linux
    https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview


2. Python version 3.10
    https://www.python.org/
    
    > Pyenv (optional)
    https://github.com/pyenv/pyenv
    https://realpython.com/intro-to-pyenv/


3. Docker Engine (recomended Docker Desktop)
    > Linux
    https://docs.docker.com/engine/install/ubuntu/

    > or WSL2
    https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers

    > add Docker compose v2 (comes with docker desktop)
    https://docs.docker.com/compose/cli-command/


4. PGAdmin4
    https://www.pgadmin.org/download/


5. Visual Studio Code
    https://code.visualstudio.com/download

    Suggested visual studio code extensions:
    > Pylance
    > Docker
    > Thunder Client
    > Prettier
    > ZipFS


6.  Poetry
    > Make sure to use master or version above 1.1
    https://python-poetry.org/
    `curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -`


7. GCloud (if applicable)
    > Install GCloud SDK/CLI
    https://cloud.google.com/sdk/docs/install
    (`gcloud init --no-launch-browser` if open in browser error)
    
    > Authorise Docker Cred Helper
    https://cloud.google.com/artifact-registry/docs/docker/authentication#gcloud-helper
    (eg: `gcloud auth configure-docker europe-west1-docker.pkg.dev`)

    > Create Service Account Key of signed in user for ADC
    `gcloud auth application-default login`
    `sudo chmod 644 ~/.config/gcloud/application_default_credentials.json`
    > Remember to revoke when you stop longer need access
    `gcloud auth application-default revoke`


8. Github
    > Save credentials
    `git config --global user.name "YOUR USERNAME"`
    `git config --global user.email "YOUR EMAIL"`


9. Node


	nvm:
		https://github.com/nvm-sh/nvm
		`nvm install 16`
	yarn:
		https://yarnpkg.com/getting-started/install


10. Global CLI's:
    Angular:
        npm install -g @angular/cli
        npm install -g firebase-tools
        npm install -g @ionic/cli



# ENVIRONMENT

## Ubuntu
```
sudo apt-get update && sudo apt-get upgrade
```

## Virtual Environment
> create poetry venv and install packages (then open venv in terminal to use linting)
```
cd services/frontend/src
poetry shell
poetry install
```

> paste into .vscode/settings.json settings (swap 'quickdesk-api-tLv1QZSI-py3.9' with your venv name):
```
{
    "python.defaultInterpreterPath": "~/.cache/pypoetry/virtualenvs/{{{{{{{{{{{{{{{{{your-venv-xyz-py3.10}}}}}}}}}}}}}}}}}/bin/python",
    "python.terminal.activateEnvironment": true,
    "python.analysis.extraPaths": [
        "./services/fa_api/src",
        "./services/md_web/src"
    ],
    "python.formatting.provider": "black",
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.linting.flake8Args": [
        "--max-line-length=119",
        "--exclude=alembic,env.py,git,__pycache__,__init__.py,.pytest_cache"
    ],
    "python.linting.flake8CategorySeverity.E": "Hint",
    "python.linting.flake8CategorySeverity.W": "Warning",
    "python.linting.flake8CategorySeverity.F": "Information",
    "isort.args": [
        "--profile=black"
    ],
    "jupyter.jupyterServerType": "local",
    "[typescript]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "vscode.typescript-language-features",
    },
    "search.exclude": {
        "**/.yarn": true,
        "**/.pnp.*": true
    },
    "prettier.prettierPath": "./services/md_web/app/.yarn/sdks/prettier/index.js",
    "typescript.tsdk": "./services/md_web/app/.yarn/sdks/typescript/lib",
    "typescript.enablePromptUseWorkspaceTsdk": true
}
```
> start new terminal that must automatically load into the poetry virtual environment


## Secrets
Secrets folder required from supervisor, not on Github.
Needs to be downloaded, unzipped and placed in root directory.

## Docker Service Start
```
sudo service docker start 
```
> or start docker desktop application on your system



# SCRIPTS

## Develop 
> build the images
```
sh scripts/build-dev.sh
```

> run the containers for local development
```
sh scripts/develop-local.sh
```

> run the containers connected to the live database
```
sh scripts/develop-prod.sh
```


## Run Tests
> modify the script to choose options like turning off --build
```
sh scripts/test.sh
```

## Deploy
> deploy to staging environment
```
sh scripts/deploy-to-stage.sh
```

> deploy to production environment
```
sh scripts/deploy-to-prod.sh
```


# COMMANDS

## Docker
> bring container down
```
docker compose down
```

> Exec into container
```
docker exec -it -u root api bash
```

> Exec bash command into container
```
docker exec -u root api bash -c "alembic upgrade head"
```


## Alembic
> Migrations
```
cd services/database/
```

```
alembic revision --autogenerate -m 'revision message'
```

```
alembic upgrade head --sql > migration.sql
```
```
alembic upgrade head
```
```
alembic downgrade -1
```


## PSQL
`
docker compose exec local-db psql -U postgres
`
`
\c quickdesk_db
`
`
\dt
`

## Jupyter Notebook
>Attach shell to backend api
```bash
jupyter-lab
```
or
```bash
jupyter lab --ip=0.0.0.0 --allow-root --NotebookApp.custom_display_url=http://127.0.0.1:8888
```
> Copy the URL of the server
> Open notebook, select remote server, paste URL
> Select remote server as kernel


## Quality
```
docker-compose exec web flake8 .
docker-compose exec web black . --check
docker-compose exec web isort . --check-only
```


## Poetry
> Upldate dependancy version in pyproject.toml
```bash
poetry add black@latest --dev
```

## FRONTEND
    ng config cli.packageManager yarn


## Ionic:
for an ionic, start with:
`ionic start`



# LOCAL PORTS:

┌──────────────────────────────────┬──────┐
│ SERVICE                          │ PORT │
├──────────────────────────────────┼──────┤
│ QuickDesk                        │ 5000 │
├──────────────────────────────────┼──────┤
│ QR Space API                     │ 8000 │
├──────────────────────────────────┼──────┤
│ MFA API                          │ 8081 │
├──────────────────────────────────┼──────┤
│ QuickDash                        │ 5003 │
├──────────────────────────────────┼──────┤
│ QuickDesk 3                      │ 8100 │
└──────────────────────────────────┴──────┘




# TROUBLESHOOTING

if the container is running different .env file to the one in your local volume, then rebuild the container for local



# NEW ANGULAR PROJECT SETUP

``

`ionic start app`

`cd app`

`yarn set version berry`

`yarn install`

add ".yarn" to gitignore