#!/usr/bin/env bash
### The script installs the latest version of Docker and checks that the version is at least 29.*
set -euxo pipefail

apt update
apt install -y docker-ce --no-install-recommends
rm -rf /var/lib/apt/lists/*
apt-get clean

docker --version | grep -E "Docker version (29\.|[3-9][0-9]\.)" \
    || (echo "Docker version must be at least 29.*" && exit 1)
