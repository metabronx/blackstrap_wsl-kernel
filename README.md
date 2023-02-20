# blackstrap-wsl-kernel

A Windows Subsystem for Linux kernel originally built for blackstrap.

This kernel can be used wherever WSL needs to support applications that require `CONNMARK`, like Wireguard in Docker (<https://docs.linuxserver.io/images/docker-wireguard>).

The Dockerfile pulls and builds the latest released version of the WSL Linux kernel from <https://github.com/microsoft/WSL2-Linux-Kernel>. Building the kernel takes 10-15 minutes.

The built kernel is saved to `/kernel` within the image and can be copied out for use:

```powershell
docker build . -t blackstrap-wsl-kernel
docker cp "$(docker create --rm blackstrap-wsl-kernel):/kernel" ~/kernel
```

To use it, specify the custom kernel in your `~/.wslconfig` file and restart WSL with `wsl --shutdown`:

```plain
[wsl2]
kernel=PATH_TO_KERNEL
```

# License

Put a license here.