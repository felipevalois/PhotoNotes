//
//  PhotoNoteViewController.swift
//  PhotoNotes
//
//  Created by Felipe Costa on 7/5/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit
import MobileCoreServices


class PhotoNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var noteImageView: UIImageView!
    
    var newMedia: Bool?
    var note: PhotoNote?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        if let note = note {
            let name = note.name
            nameTextField.text = name
            contentTextView.text = note.content
            noteImageView.image = note.image
            title = name
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func titleChanged(_ sender: Any) {
        title = nameTextField.text
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        
        if (mediaType.isEqual(to: kUTTypeImage as String)){
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            noteImageView.image = image
            if (newMedia == true){
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoNoteViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            
        }
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        if (error != nil){
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addPhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Photo", message: "Please choose from your camera roll or take a new picture", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertAction.Style.default, handler: {
            (UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newMedia = false
                return
            }
        }))
        alert.addAction(UIAlertAction(title: "Use Camera", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newMedia = true
                return
            }
            else{
                let alert = UIAlertController(title: "No Camera", message: "The device has no camera", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func savePhotoNote(_ sender: Any) {
        guard let name = nameTextField.text else {
            alertNotifyUser(message: "Document not saved.\nThe name is not accessible.")
            return
        }
        
        let noteName = name.trimmingCharacters(in: .whitespaces)
        if (noteName == "") {
            alertNotifyUser(message: "Document not saved.\nA name is required.")
            return
        }
        
        let content = contentTextView.text
        
        let image = noteImageView.image
        
        if note == nil {
            // document doesn't exist, create new one
            note = PhotoNote(name: noteName, content: content, image: image )
        } else {
            // document exists, update existing one
            note?.update(name: noteName, content: content, image: image)
        }
        
        if let note = note {
            do {
                let managedContext = note.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "The document context could not be saved.")
            }
        } else {
            alertNotifyUser(message: "The document could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
    }
}
