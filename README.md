Krabiner Profile Switcher
=========================

Switch to a given [karabiner-elements](https://github.com/tekezo/Karabiner-Elements) profile when a specific keyboard is attached.

Usage:

    kps \
      --default-profile 'Built-in keyboard' \
      --device-profile 'Kinesis Advantage' \
      --vendor-id 0x05f3 \
      --product-id 0x0081

To find the vendor and product id for your keyboard, attach it and go to Apple Menu → About This Mac → System Report and look under *USB*.

To build:

    swift build

To generate an Xcode project:

    swift package generate-xcodeproj
