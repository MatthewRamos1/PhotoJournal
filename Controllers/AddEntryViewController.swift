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
    private let alertController = UIAlertController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showImageController() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func addGalleryImagePressed(_ sender: UIBarButtonItem) {
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (alertAction) in
            self?.showImageController()
        }
        alertController.addAction(photoLibraryAction)
    }
    
    @IBAction func addCameraImagePressed(_ sender: UIBarButtonItem) {
    }
    
    
}
