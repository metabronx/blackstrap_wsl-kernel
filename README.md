# blackstrap-wsl-kernel

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/metabronx/blackstrap-wsl-kernel/build.yaml?label=latest%20build&style=flat-square)

A Windows Subsystem for Linux kernel originally built for blackstrap.

This kernel can be used wherever WSL needs to support applications that require `CONNMARK`, like Wireguard in Docker (<https://docs.linuxserver.io/images/docker-wireguard>).

The Dockerfile pulls and builds the latest released version of the WSL Linux kernel from <https://github.com/microsoft/WSL2-Linux-Kernel>. Building the kernel takes 10-15 minutes.

The built kernel is saved to `/wsl-kernel` within the image and can be copied out for use:

```powershell
# build
docker build . -t blackstrap-wsl-kernel

# extract kernel image
docker create --name blackstrap-wsl-kernel
docker cp blackstrap-wsl-kernel:/wsl-kernel PATH_TO_SAVE
docker rm blackstrap-wsl-kernel
```

To use it, specify the custom kernel in your `~/.wslconfig` file and restart WSL with `wsl --shutdown`. Also ensure to escape the path (`\` should be `\\`) you set.

```plain
[wsl2]
kernel=PATH_TO_KERNEL
```

# License

Put a license here.
