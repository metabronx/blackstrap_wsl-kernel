FROM python:3-slim

SHELL [ "/bin/bash", "-eo", "pipefail", "-c" ]
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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ## download latest WSL kernel
    echo "> Downloading latest WSL kernel..." && \
    curl -fSL "$(curl -fSL --compressed \
            https://api.github.com/repos/microsoft/WSL2-Linux-Kernel/releases/latest | \
            jq -r '.tarball_url')" | tar -xz && \
    ## configure and build the kernel
    ### WireGuard needs the ability to attach packets to "marks" and those
    ### "marks" to connections. The latter function is exposed via the CONNMARK iptables
    ### extension, but needs to be enabled when WSL builds the Linux kernel module
    echo "> Configuring and building..." && \
    cd microsoft-WSL2-Linux-Kernel* && \
    echo -e "CONFIG_NETFILTER_XT_MATCH_CONNMARK=y\nCONFIG_NETFILTER_XT_CONNMARK=y" >> \
        Microsoft/config-wsl && \
    make -j "$(nproc)" KCONFIG_CONFIG=Microsoft/config-wsl && \
    mv arch/x86/boot/bzImage /kernel && \
    make distclean
