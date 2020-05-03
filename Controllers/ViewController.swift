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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEntries()
    }
    
    func loadEntries() {
        do {
            try entries = dataPersistence.loadItems()
        } catch {
            fatalError("Couldnt load entries")
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
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
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


