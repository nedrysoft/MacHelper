# Nedrysoft MacHelper Library

The MacHelper library provides classess for interactive with cocoa via Qt objects.  It provides:

- A NSToolbar based implementation that supports the "preferences" style in Big Sur or later.
- A NSStatusbar based implementation for creating menu bar icons.
- A NSPopover based implementation for creating standard macOS popover windows.
- A NSAlert based implementation for creating native looking message boxes, particularly useful because the style is very different under Big Sur to what the QMessageBox implementation provides.
- Functions for converting images to and from NSImage.
- Functions for retrieving system fonts.
- Functions for retrieving standard OS icons.

## Requirements

* Qt5 or Qt6
* CMake

## Building

To build the library, invoke CMake or open the CMakeLists.txt file in your preferred IDE.

Setting the following CMake variables allows the customisation of the build.

```
NEDRYSOFT_MACHELPER_LIBRARY_DIR=<dir>
```

Sets the output folder for the dynamic library; if omitted, you can find the binaries in the default location.

# License

This project is open source and released under the GPLv3 licence.

Distributed as-is; no warranty is given.
