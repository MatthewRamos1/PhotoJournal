//
//  UserSettings.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 5/4/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation

class UserSettings {
    private init () {}
    private let standard = UserDefaults.standard
    static let shared = UserSettings()
    
    struct SettingsKind {
        static let scrollSetting = "ScrollSetting"
        static let colorSetting = "ColorSetting"
    }
    
    func updateScrollSetting (scrollDirection: String) {
        standard.set(scrollDirection, forKey: SettingsKind.scrollSetting)
    }
    
    func getScrollSetting () -> String? {
        guard let scrollSetting = UserDefaults.standard.object(forKey: SettingsKind.scrollSetting) as? String else {
            return nil
        }
        return scrollSetting
    }
    
    func updateColorSetting(color: String) {
        standard.set(color, forKey: SettingsKind.colorSetting)
    }
    
    func getColorSetting() -> String? {
        guard let colorSetting = UserDefaults.standard.object(forKey: SettingsKind.colorSetting) as? String else {
            return nil
        }
        return colorSetting
    }
}
