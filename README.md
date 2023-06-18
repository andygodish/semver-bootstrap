# Semver Bootstrap

## Summary

This tool bootstraps a simple semantic versioning scheme that leverages the Node.js package, [semantic-release](https://semantic-release.gitbook.io/semantic-release/). 

The logic is included in the shell scripts within this directory and packaged into a docker container that can be executed in an ephemeral manner from your local machine. 

### Quickstart

1. Clone this repository
2. Build the Dockerfile:

```
docker build -t semver-bootstrap:local .
```

3. From the root directory of your project, exectue the docker container:

```
docker run -e UID=$(id -u) -e GID=$(id -g) -v $PWD:/work -t semver-bootstrap:local
```

> **Passing in User and Group IDs** ---> The docker container execution works by accessing your local file system by creating a volume mount at the root of your project directory, `-v $PWD:/work`. The `/work` directory is definied as the `WORKDIR` in the Dockerfile. Passing in your local user and group id allows the ownership of new files to be properly assigned on your local machine. 

The result is the creation of the following:

1. A `semver` directory containing npm package configurations. This is a basic `semantic-release` setup that is executed by Github Actions.

2. A standard github actions workflow file, `./github/workflows/semantic-version.yaml`. Edit this to suite your needs.

3. A `.gitignore` file to prevent node_modules from being pushed to your remote repository. 

## Additional Resources

### Descripttion.txt

The Docker container uses jq to replace the `description` field in the `./semver/package.json` file. 

test