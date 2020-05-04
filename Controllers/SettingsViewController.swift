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

class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var scrollDirectionLabel: UILabel!
    @IBOutlet weak var backgroundColorLabel: UILabel!
    
    var scrollDirection = ScrollSetting.vertical {
        didSet {
            scrollDirectionLabel.text = scrollDirection.rawValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let temp = UserSettings.shared.getScrollSetting() else {
            return
        }
        if temp == ScrollSetting.vertical.rawValue {
            scrollDirection = ScrollSetting.vertical
        } else {
            scrollDirection = ScrollSetting.horizontal
        }
        

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
            backgroundColorLabel.text = "temp"
        }
    }

}
