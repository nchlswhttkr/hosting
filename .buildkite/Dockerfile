FROM python:3.11-bookworm

RUN curl --fail --location --show-error --silent https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | gpg --output /usr/share/keyrings/tailscale-archive-keyring.gpg
RUN curl --fail --location --show-error --silent https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
RUN apt-get -y update && apt-get -y install tailscale
