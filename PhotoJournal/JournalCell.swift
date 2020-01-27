//
//  JournalCell.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 1/26/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class JournalCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var entryNameLabel: UILabel!
    @IBOutlet weak var dateNameLabel: UILabel!
    
    
    private lazy var longPressGesture: UILongPressGestureRecognizer =   {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
        backgroundColor = .green
        addGestureRecognizer(longPressGesture)
    }
    
    
    
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state ==  .began {
            gesture.state = .cancelled
            return
        }
        
    }
    
    public func configureCell(journalEntry: JournalEntry) {
        guard let image = UIImage(data: journalEntry.imageData) else {
            return
        }
        imageView.image = image
        entryNameLabel.text = journalEntry.entryName
        dateNameLabel.text = journalEntry.date.description
    }
}
