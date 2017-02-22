//
//  ProfileSwitcher.swift
//  Karabiner Profile Switcher
//
//  Created by Erlend Hamberg on 22/02/2017.
//  Copyright © 2017 Erlend Hamberg. All rights reserved.
//

import Foundation
import SwiftyJSON

func enableProfile(profileName: String) {
    let configFile = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent(".config/karabiner/karabiner.json")

    guard let config = try? String(contentsOf: configFile, encoding: .utf8) else {
        fatalError("Error when reading config file \(configFile)")
    }

    var json = JSON(parseJSON: config)

    var idx = 0
    var updated = 0
    for (_, var profileJson) in json["profiles"] {
        guard let name = profileJson["name"].string else {
            fatalError("Error while reading profiles from config")
        }

        // if the name matches, set it as the selected profile, otherwise deselect it
        if name == profileName {
            profileJson["selected"].bool = true
            json["profiles"][idx] = profileJson

            updated += 1
        } else {
            profileJson["selected"].bool = false
            json["profiles"][idx] = profileJson
        }

        idx += 1
    }

    switch updated {
    case 0:
        fatalError("Profile “\(profileName)” not found")
    case 1:
        do {
            try json.description.write(to: configFile, atomically: true, encoding: .utf8)
            print("Wrote updated karabiner config.")
        } catch {
            fatalError("Error when writing config file: \(error)")
        }
    default:
        fatalError("Found more than one profile matching “\(profileName)” o_O")
    }
}
