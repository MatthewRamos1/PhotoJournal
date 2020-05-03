//
//  Date + Extensions.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 5/3/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation

extension Date{
    public func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
