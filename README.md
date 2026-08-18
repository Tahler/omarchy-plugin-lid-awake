# omarchy-plugin-lid-awake

An Omarchy shell plugin that, when active, prevents suspend when the laptop lid closes. The session still locks like normal, but processes are not stopped.

## Install

```sh
omarchy plugin add https://github.com/Tahler/omarchy-plugin-lid-awake.git --enable
```

The laptop icon appears in the top-right bar section. Click it to pause or resume the inhibitor. It pauses automatically when the Omarchy shell exits (e.g. on reboot).

## Uninstall

```sh
omarchy plugin remove io.github.tahler.lid-awake
```

## Dependencies

No external dependencies.
