# PolyMC Overlay

Officially maintained ebuilds for the PolyMC launcher. If you encounter any problems or have any suggestions, feel free to open an issue [here](https://github.com/PolyMC/overlay/issues)!

Also, if you want to contribute something to this effort, feel free to open a PR. Contributions are always welcome :)

## Enabling manually

Write this to `/etc/portage/repos.conf/polymc.conf`:

```ini
[polymc]
location = /var/db/repos/polymc
sync-type = git
sync-uri = https://github.com/PolyMC/overlay.git
```

## Enabling with eselect-repository

TODO: Gentoo's repositories.xml needs to be PR'd with this repository.

When this is done, run as root:

```sh
emerge --oneshot --noreplace eselect-repository
eselect repository enable polymc
```

## Syncing

To download and/or update the overlay, run the following command as root:

```sh
emaint sync -r polymc
```

This should be done after either of the previous two steps.

## Downloading PolyMC

After the repository has been enabled and synced, you can now run `emerge polymc` as root to install the latest version of PolyMC

If you want to build from the latest commit, run:

```sh
echo "=games-action/polymc-9999 ** | sudo tee -a /etc/portage/package.accept_keywords/00-polymc
```

If your `accept_keywords` is simply a file, remove the final `/polymc`.

After this is done, you can simply `emerge polymc` and it will build and install from the latest commit.

## Flags and features

### USE Flags

Currently, the following USE flags are available:

- `debug`: Enable debug output, useful for development and troubleshooting
- `lto`: Enable Link-Time Optimization (LTO)
- `test`: Build test suite

### Optional dependencies

These are dependencies that **may** be required for certain launcher / Minecraft features, but can be installed / uninstalled from your system at any time you want:

- `x11-libs/libXrandr`: Minecraft versions <= 1.12.2 need this to work properly (See [this issue](https://github.com/PolyMC/PolyMC/issues/227))
- `games-util/mangohud`: For built-in MangoHud support
- `games-util/gamemode`: For built-in Feral Gamemode support
