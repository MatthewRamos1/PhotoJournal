//
//  SettingsViewController.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 4/30/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

enum ScrollSetting: String {
    case horizontal = "Horizontal"
    case vertical = "Vertical"
}

enum Color: String {
    case white = "White"
    case red = "Red"
    case teal = "Teal"
    case yellow = "Yellow"
}


class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var scrollDirectionLabel: UILabel!
    @IBOutlet weak var backgroundColorLabel: UILabel!
    
    var scrollDirection = ScrollSetting.vertical {
        didSet {
            scrollDirectionLabel.text = scrollDirection.rawValue
        }
    }
    
    var backgroundColor = Color.white {
        didSet {
            backgroundColorLabel.text = backgroundColor.rawValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getSettings()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if scrollDirection == ScrollSetting.vertical {
                let scrollSetting = ScrollSetting.horizontal.rawValue
                UserSettings.shared.updateScrollSetting(scrollDirection: scrollSetting)
                scrollDirection = ScrollSetting.horizontal
            } else {
                let scrollSetting = ScrollSetting.vertical.rawValue
                UserSettings.shared.updateScrollSetting(scrollDirection: scrollSetting)
                scrollDirection = ScrollSetting.vertical
            }
        default:
            switch backgroundColor {
            case Color.white:
                UserSettings.shared.updateColorSetting(color: Color.red.rawValue)
                backgroundColor = Color.red
            case Color.red:
                UserSettings.shared.updateColorSetting(color: Color.teal.rawValue)
                backgroundColor = Color.teal
            case Color.teal:
                UserSettings.shared.updateColorSetting(color: Color.yellow.rawValue)
                backgroundColor = Color.yellow
            case Color.yellow:
                UserSettings.shared.updateColorSetting(color: Color.white.rawValue)
                backgroundColor = Color.white
            }
        }
    }
    
    private func getSettings() {
        guard let tempDirection = UserSettings.shared.getScrollSetting() else {
            return
        }
        if tempDirection == ScrollSetting.vertical.rawValue {
            scrollDirection = ScrollSetting.vertical
        } else {
            scrollDirection = ScrollSetting.horizontal
        }
        
        guard let tempColor =
            UserSettings.shared.getColorSetting() else {
                return
        }
        switch tempColor {
        case Color.white.rawValue:
            backgroundColor = Color.white
        case Color.red.rawValue:
            backgroundColor = Color.red
        case Color.teal.rawValue:
            backgroundColor = Color.teal
        default:
            backgroundColor = Color.yellow
            
            }
        }
    }
