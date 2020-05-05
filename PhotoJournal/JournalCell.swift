//
//  JournalCell.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 1/26/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

protocol JournalCellDelegate: AnyObject {
    func didLongPress(cell: JournalCell)
}

class JournalCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var entryNameLabel: UILabel!
    @IBOutlet weak var dateNameLabel: UILabel!
    public var indexVal = 0
    
    weak var delegate: JournalCellDelegate?
    
    
    private lazy var longPressGesture: UILongPressGestureRecognizer =   {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemBackground
        addGestureRecognizer(longPressGesture)
    }
    
    
    
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer) {
        delegate?.didLongPress(cell: self)
        
    }
    
    public func configureCell(journalEntry: JournalEntry) {
        guard let image = UIImage(data: journalEntry.imageData) else {
            return
        }
        imageView.image = image
        entryNameLabel.text = journalEntry.entryName
        dateNameLabel.text = journalEntry.date.dateFormatter()
    }
}
