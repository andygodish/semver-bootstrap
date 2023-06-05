#!/bin/bash

u=$UID
g=$GID


# tput colors --- requries the installation of ncurses in the Dockerfile
green=$(tput setaf 2)
red=$(tput setaf 1)
no_color=$(tput sgr0)

# Verify correct version of npm is installed
npm_min_version="5.2.0"
npm_version=$(npm --version)

if [ "$(printf '%s\n' "$npm_min_version" "$npm_version" | sort -V | head -n1)" != "$npm_min_version" ]; then
    echo "${red}npm version is less than $npm_min_version${no_color}"
    exit 1
else
    echo "${green}npm version is equal to or higher than $npm_min_version ($npm_version)${no_color}"
fi

# Verify correct version of node is installed
node_min_version="18.0.0"
node_version=$(node --version | sed 's/^v//')

if [ "$(printf '%s\n' "$node_min_version" "$node_version" | sort -V | head -n1)" != "$node_min_version" ]; then
    echo "${red}node version is less than $node_min_version${no_color}"
    exit 1
else
    echo "${green}node version is equal to or higher than $node_min_version ($node_version)${no_color}"
fi

# Verify correct version of git is installed
git_min_version="2.7.1"
git_version=$(git --version | awk '{print $3}')

if [ "$(printf '%s\n' "$git_min_version" "$git_version" | sort -V | head -n1)" != "$git_min_version" ]; then
    echo "${red}git version is less than $git_min_version${no_color}"
    exit 1
else
    echo "${green}git version is equal to or higher than $git_min_version ($git_version)${no_color}"
fi

# todo: add check for npm and node versions based on requirements in documentation
# git: https://semantic-release.gitbook.io/semantic-release/support/git-version - 2.7.1+
# node/npm: https://semantic-release.gitbook.io/semantic-release/support/node-version - 18+

mkdir -p semver && cd semver

cp /work/release.config.js /work/semver/release.config.js

npm init -y \
  --init-author-name="Andy Godish" \
  --init-version="0.0.1"

jq --arg desc "$(cat /work/description.txt)" \
  '.description=$desc' package.json > tmp.json && \
   mv tmp.json package.json

# Install semantic release and required plugins
npm install --save-dev semantic-release @semantic-release/git @semantic-release/github


if [ "$u" -ne 1000 ] || [ "$g" -ne 1000 ]; then
    adduser --disabled-password --gecos "" --uid $u semver
    chown -R semver:semver .
else
    chown -R 1000:1000 .
fi

cd /work && /bin/bash ./git.sh

