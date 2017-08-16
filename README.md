# Karabiner Profile Switcher

> !!! This is no longer needed since karabiner elements allow you to target modifictions to specific devices !!! 

Switch to a given [karabiner-elements](https://github.com/tekezo/Karabiner-Elements) profile when a specific USB keyboard is attached (and switch back to a default profile when it is removed).

Usage:

    kps \
      --default-profile 'Built-in keyboard' \
      --device-profile 'Kinesis Advantage' \
      --vendor-id 0x05f3 \
      --product-id 0x0081

To find the vendor and product id for your keyboard, attach it and go to Apple Menu → About This Mac → System Report and look under *USB*.

## Building

To build:

    swift build -c release

The binary will end up in `.build/release/kps`.

## Running

You probably want to run this as a [launchd agent](http://www.launchd.info). To do this, first make sure that it works when you run it from the shell. Then, when you know exactly which arguments it should take, create a launchd agent config in `~/Library/LaunchAgents/no.hamberg.karabiner-profile-switcher.plist` with the following contents (replace the arguments and make sure the path to `kps` is correct):

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>no.hamberg.karabiner-profile-switcher</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/local/bin/kps</string>
          <string>--default-profile</string>
          <string>Built-in keyboard</string>
          <string>--device-profile</string>
          <string>Kinesis Advantage</string>
          <string>--vendor-id</string>
          <string>0x05f3</string>
          <string>--product-id</string>
          <string>0x0081</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>

The agent should then be launched on the next boot and run in the background. To launch it this time, without rebooting, run the following command:

    launchctl load ~/Library/LaunchAgents/no.hamberg.karabiner-profile-switcher.plist

## Hacking

To generate an Xcode project:

    swift package generate-xcodeproj

To run the linter:

    swiftlint
