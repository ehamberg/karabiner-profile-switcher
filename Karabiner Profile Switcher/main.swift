//
//  main.swift
//  Karabiner Profile Switcher
//
//  Created by Erlend Hamberg on 22/02/2017.
//  Copyright © 2017 Erlend Hamberg. All rights reserved.
//

import Foundation

let defaultProfile = "Built-in keyboard"
let deviceProfile = "Kinesis Advantage"
let vendorId = 0x05f3
let productId = 0x0081

let keyboardDetector = IOUSBDetector(vendorID: vendorId, productID: productId)
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
};

_ = keyboardDetector?.startDetection()

signal(2, {
    signal in
    keyboardDetector?.stopDetection()
    exit(0)
})

while true { sleep(1) }
