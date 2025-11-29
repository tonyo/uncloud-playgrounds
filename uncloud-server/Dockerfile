FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker

RUN sudo sh -c 'apt update && apt install -y docker-ce=5:29.* --no-install-recommends'

# Replace with curl after install is fixed
COPY install.sh /opt/install.sh

RUN sudo INSTALL_ONLY=true bash /opt/install.sh
