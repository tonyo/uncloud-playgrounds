FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker

# Update Docker to latest stable
RUN --mount=type=bind,source=scripts,target=/tmp/scripts sudo /tmp/scripts/install-docker.sh

# Install Uncloud components
RUN curl -fsS https://raw.githubusercontent.com/psviderski/uncloud/refs/heads/main/scripts/install.sh \
    | sudo INSTALL_ONLY=true bash
