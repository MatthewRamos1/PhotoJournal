//
//  AddEntryViewController.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 1/27/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import AVFoundation
import DataPersistence

class AddEntryViewController: UIViewController {
    
    @IBOutlet weak var journalEntryTextView: UITextView!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var entryTextView: UITextView!
    
    private var imagePickerController = UIImagePickerController()
    private let dataPersistence = DataPersistence<JournalEntry>(filename: "images.plist")
    private var selectedImage: UIImage? {
        didSet {
            saveNewPhoto()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    
    func createJournalEntry(image: UIImage) -> JournalEntry? {
        guard let image = selectedImage else {
            return nil
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let journalEntry = JournalEntry(imageData: resizedImageData, entryName: "", date: Date())
        return journalEntry
    }
    
    private func saveNewPhoto() {
        guard let image = selectedImage else {
            fatalError("Couldn't access image, check save function")
        }
        guard let journalEntry = createJournalEntry(image: image) else {
            fatalError("Couldn't access ImageObject, check save function")
        }
        do {
            try dataPersistence.createItem(journalEntry)
            print("item was saved")
        } catch {
            fatalError("Couldn't create item, check save function")
        }
        
        
    }
    private func setImageController() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func addGalleryImagePressed(_ sender: UIBarButtonItem) {
        setImageController()
    }
    
    @IBAction func addCameraImagePressed(_ sender: UIBarButtonItem) {
    }
    
    
    
}

extension AddEntryViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Error", message: "Image was not found")
            return
        }
        selectedImage = image
    }
}
