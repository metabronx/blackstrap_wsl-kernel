# syntax=docker/dockerfile:1

FROM python:3-slim as compiler

SHELL [ "/bin/bash", "-eo", "pipefail", "-c" ]
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get --yes --no-install-recommends --no-install-suggests install \
        curl \
        ca-certificates \
        jq \
        build-essential \
        flex \
        bison \
        dwarves \
        libssl-dev \
        libelf-dev \
        bc \
        binutils \
        kmod && \
    ## download latest WSL kernel
    echo "> Downloading latest WSL kernel..." && \
    curl -fSL --compressed "$(curl -fSL --compressed \
            https://api.github.com/repos/microsoft/WSL2-Linux-Kernel/releases/latest | \
            jq -r '.tarball_url')" | tar -xz && \
    ## configure and build the kernel
    ### WireGuard needs the ability to attach packets to "marks" and those
    ### "marks" to connections. The latter function is exposed via CONNMARK,
    ### which needs to be enabled when building the Linux kernel.
    echo "> Configuring and building..." && \
    cd microsoft-WSL2-Linux-Kernel* && \
    echo -e "CONFIG_NETFILTER_XT_MATCH_CONNMARK=y\nCONFIG_NETFILTER_XT_CONNMARK=y" >> \
        Microsoft/config-wsl && \
    make -j"$(nproc)" KCONFIG_CONFIG=Microsoft/config-wsl && \
    mv arch/x86/boot/bzImage /wsl-kernel


FROM scratch

LABEL org.opencontainers.image.description="A WSL kernel for CONNMARK applications."
LABEL org.opencontainers.image.vendor="The Concourse Group Inc DBA MetaBronx"
LABEL org.opencontainers.image.authors="Elias Gabriel <me@eliasfgabriel.com>"
LABEL org.opencontainers.image.source="https://github.com/metabronx/blackstrap-wsl-kernel"
# LABEL org.opencontainers.image.licenses="MIT"

COPY --from=compiler /wsl-kernel /wsl-kernel
