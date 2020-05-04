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
    private let scrollSetting = "ScrollSetting"
    func updateScrollSetting (scrollDirection: String) {
        standard.set(scrollDirection, forKey: scrollSetting )
    }
    
    func getScrollSetting () -> String? {
        guard let scrollSetting = UserDefaults.standard.object(forKey: scrollSetting) as? String else {
            return nil
        }
        return scrollSetting
    }
}
