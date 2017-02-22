//
//  main.swift
//  Karabiner Profile Switcher
//
//  Created by Erlend Hamberg on 22/02/2017.
//  Copyright © 2017 Erlend Hamberg. All rights reserved.
//

import Foundation
import CommandLineKit

let cli = CommandLineKit.CommandLine()

let defaultProfile = StringOption(
    longFlag: "default-profile",
    required: true,
    helpMessage: "Name of the default profile.")
let deviceProfile = StringOption(
    longFlag: "device-profile",
    required: true,
    helpMessage: "Name of the device-specific profile.")
let vendorId = StringOption(
    longFlag: "vendor-id",
    required: true,
    helpMessage: "Vendor id for your keyboard, e.g. 0x05f3")
let productId = StringOption(
    longFlag: "product-id",
    required: true,
    helpMessage: "Product id for your keyboard, e.g. 0x0081")
let help = BoolOption(
    shortFlag: "h",
    longFlag: "help",
    helpMessage: "Prints a help message.")

cli.addOptions(defaultProfile, deviceProfile, vendorId, productId, help)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

// get this out of the way, we're going to need all of these…
guard let defaultProfile = defaultProfile.value,
      let deviceProfile = deviceProfile.value,
      let vid = vendorId.value,
      let vid = Int(vid.substring(from: vid.index(vid.startIndex, offsetBy: 2)), radix: 16),
      let pid = productId.value,
      let pid = Int(pid.substring(from: pid.index(pid.startIndex, offsetBy: 2)), radix: 16)
    else {
        fatalError("Error when parsing argument values.")
}

let keyboardDetector = IOUSBDetector(vendorID: vid, productID: pid)
keyboardDetector?.callbackQueue = DispatchQueue.global()
keyboardDetector?.callback = {
    (detector, event, service) in
    switch event {
    case .Matched:
        print("Connected. Enabling device profile (\(deviceProfile))")
        enableProfile(profileName: deviceProfile)
    case .Terminated:
        print("Connected. Enabling default profile (\(defaultProfile))")
        enableProfile(profileName: defaultProfile)
    }
}

_ = keyboardDetector?.startDetection()

signal(2, { _ in
    keyboardDetector?.stopDetection()
    exit(0)
})

while true { sleep(1) }
