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
    
 
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryImage: UIImageView!
    
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
    
    func createJournalEntry(image: UIImage, description: String) -> JournalEntry? {
        guard let image = selectedImage else {
            return nil
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let journalEntry = JournalEntry(imageData: resizedImageData, entryName: description, date: Date())
        return journalEntry
    }
    
    private func saveNewPhoto() {
        guard let description = entryTextField.text, !description.isEmpty else {
            dismiss(animated: true)
            showAlert(title: "Missing Description", message: "Please fill out the necessary field.")
            return
        }
        guard let image = selectedImage, let journalEntry = createJournalEntry(image: image, description: description) else {
            fatalError("Couldn't create journalEntry, check save function")
        }
       
        do {
            try dataPersistence.createItem(journalEntry)
            dismiss(animated: true)
            showAlert(title: "Success", message: "Item was saved")
            entryTextField.text = ""
        } catch {
            fatalError("Couldn't create item, check save function")
        }
        
        
    }
    
    @IBAction func addGalleryImagePressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func addCameraImagePressed(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true)
        }
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
