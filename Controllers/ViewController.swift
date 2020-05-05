//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 1/26/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import DataPersistence


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataPersistence = DataPersistence<JournalEntry>(filename: "images.plist")
    
    var entries = [JournalEntry]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var selectedImage: UIImage?
    private var currentSetting = ScrollSetting.vertical {
        didSet {
            switch currentSetting {
            case .vertical:
                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical
                }
            case .horizontal:
                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
            }
        }
    }
    
    private var currentBackgroundColor = Color.white {
        didSet {
            switch currentBackgroundColor {
            case .white:
                collectionView.backgroundColor = .white
            case .red:
                collectionView.backgroundColor = .systemRed
            case .teal:
                collectionView.backgroundColor = .systemTeal
            case .yellow:
                collectionView.backgroundColor = .systemYellow
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEntries()
        updateScrollDirection()
        updateColor()
    }
    
    func loadEntries() {
        do {
            try entries = dataPersistence.loadItems()
        } catch {
            fatalError("Couldnt load entries")
        }
    }
    
    func deleteEntry(_ val: Int) {
        do {
            try dataPersistence.deleteItem(at: val)
        } catch {
            showAlert(title: "Error", message: "Couldn't delete item")
        }
    }
    
    func editEntry() {
        do {
            
        }
    }
    
    private func updateScrollDirection() {
        if UserSettings.shared.getScrollSetting() == ScrollSetting.vertical.rawValue {
            currentSetting = .vertical
        } else {
            currentSetting = .horizontal
        }
    }
    
    private func updateColor() {
        let colorVal = UserSettings.shared.getColorSetting()
        switch colorVal {
        case Color.white.rawValue:
            currentBackgroundColor = .white
        case Color.red.rawValue:
            currentBackgroundColor = .red
        case Color.teal.rawValue:
            currentBackgroundColor = .teal
        default:
            currentBackgroundColor = .yellow
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "journalCell", for: indexPath) as? JournalCell else {
            fatalError("Error: Could not downcast to JournalCell")
        }
        cell.delegate = self
        let entry = entries[indexPath.row]
        cell.configureCell(journalEntry: entry)
        cell.indexVal = indexPath.row
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 0.85
        return CGSize(width: width, height: width)
    }
}



extension ViewController: JournalCellDelegate {
    func didLongPress(cell: JournalCell) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
            self?.deleteEntry(cell.indexVal)
            self?.loadEntries()
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] alertAction in
            self?.editEntry()
            self?.loadEntries()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Could not find image")
        }
        selectedImage = image
    }
}


