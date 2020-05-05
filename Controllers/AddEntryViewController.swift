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
    
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var descriptionConstraint: NSLayoutConstraint!
    
    private var imagePickerController = UIImagePickerController()
    public var dataPersistence: DataPersistence<JournalEntry>?
    private var heightChanged: CGFloat = 0.0
    private var keyboardIsVisable = false
    public var index: Int?
    public var selectedEntry: JournalEntry?
    private var selectedImage: UIImage? {
        didSet {
            entryImage.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        entryTextField.delegate = self
        if let entry = selectedEntry {
            entryTextField.text = entry.entryName
            selectedImage = UIImage(data: entry.imageData)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveNewPhoto()
    }
    
    func createJournalEntry(image: UIImage, description: String, identifier: String?) -> JournalEntry? {
        guard let image = selectedImage else {
            return nil
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let journalEntry = JournalEntry(imageData: resizedImageData, entryName: description, date: Date(), identifier: identifier ?? UUID().uuidString )
        return journalEntry
    }
    
    private func saveNewPhoto() {
        guard let description = entryTextField.text, !description.isEmpty else {
            showAlert(title: "Missing Description", message: "Please fill out the necessary field.")
            return
        }
        guard let image = selectedImage, let journalEntry = createJournalEntry(image: image, description: description, identifier: selectedEntry?.identifier) else {
            showAlert(title: "Missing Image", message: "Please select an image.")
            return
        }
        
        if selectedEntry != nil {
            dataPersistence?.update(journalEntry, at: index!)
            navigationController?.popViewController(animated: true)
        } else {
            do {
                try dataPersistence?.createItem(journalEntry)
                showAlert(title: "Success", message: "Item was saved")
                entryTextField.text = ""
            } catch {
                fatalError("Couldn't create item, check save function")
            }
        }
        
        
    }
    
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        
        guard let keyboardFrame = notification.userInfo?[ "UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        moveKeyboardUp(keyboardFrame.size.height / 3.1)
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        
    }
    
    private func moveKeyboardUp(_ height: CGFloat) {
        instructionLabel.isHidden = true
        if keyboardIsVisable { return }
        keyboardIsVisable = true
        descriptionConstraint.constant -= height
        heightChanged = height
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func moveKeyboardDown() {
        instructionLabel.isHidden = false
        if keyboardIsVisable {
            keyboardIsVisable = false
            descriptionConstraint.constant += heightChanged
            UIView.animate(withDuration: 0.7) {
                self.view.layoutIfNeeded()
            }
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
        dismiss(animated: true)
    }
}

extension AddEntryViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveKeyboardDown()
        return textField.resignFirstResponder()
    }
    
}
