//
//  SettingsViewController.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 4/30/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var scrollDirectionLabel: UILabel!
    @IBOutlet weak var backgroundColorLabel: UILabel!
    
    var verticalScroll = true

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if verticalScroll {
                scrollDirectionLabel.text = "Horizontal"
                verticalScroll = false
            } else {
                scrollDirectionLabel.text = "Vertical"
                verticalScroll = true
            }
        default:
            backgroundColorLabel.text = "temp"
        }
    }

}
