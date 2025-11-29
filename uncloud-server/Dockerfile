FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker

# Update Docker to latest stable
RUN --mount=type=bind,source=scripts,target=/tmp/scripts sudo /tmp/scripts/install-docker.sh

# FIXME: Replace with curl after install.sh is updated
COPY uncloud-server/install.sh /opt/install.sh

RUN sudo INSTALL_ONLY=true bash /opt/install.sh
