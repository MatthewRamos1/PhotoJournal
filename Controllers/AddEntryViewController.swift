//
//  AddEntryViewController.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 1/27/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {
    
    @IBOutlet weak var journalEntryTextView: UITextView!
    @IBOutlet weak var entryImage: UIImageView!
    
    private var imagePickerController = UIImagePickerController()
    private var selectedImage: UIImage? {
        didSet {
            appendNewPhotoToJournal()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func appendNewPhotoToJournal() {
        
    }
    private func setImageController() {
        imagePickerController.sourceType = .photoLibrary
        
    }
    
    @IBAction func addGalleryImagePressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController()
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (alertAction) in
            self?.setImageController()
        }
        alertController.addAction(photoLibraryAction)
        present(imagePickerController, animated: true)
    }
    
    @IBAction func addCameraImagePressed(_ sender: UIBarButtonItem) {
    }
    
    
}

extension AddEntryViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Error", message: "Image was not found")
            return
        }
        selectedImage = image
    }
}
