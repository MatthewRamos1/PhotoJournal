//
//  JournalEntry.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 1/26/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation

typealias Writeable = Codable & Equatable

struct JournalEntry: Writeable {
    let imageData: Data
    let entryName: String
    let date: Date
    let identifier: String
    
}
