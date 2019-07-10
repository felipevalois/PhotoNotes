//
//  PhotoNotesViewController.swift
//  PhotoNotes
//
//  Created by Felipe Costa on 7/5/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit
import CoreData

class PhotoNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notesTableView: UITableView!
    
    var notes = [PhotoNote]()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Notes"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNotesArray()
        notesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            (alertAction) -> Void in
            print("OK selected")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateNotesArray() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PhotoNote> = PhotoNote.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)] // order results by document name ascending
        
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch {
            alertNotifyUser(message: "Fetch for documents could not be performed.")
            return
        }    }
    
    func deleteNote(at indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        if let managedObjectContext = note.managedObjectContext {
            managedObjectContext.delete(note)
            
            do {
                try managedObjectContext.save()
                self.notes.remove(at: indexPath.row)
                notesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                let alert = UIAlertController(title: "Alert", message: "Delete Failed", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                notesTableView.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath)
        
        if let cell = cell as? PhotoNotesTableViewCell {
            let note = notes[indexPath.row]
            cell.nameLabel.text = note.name
            cell.contentLabel.text = note.content
            cell.notesImageView.image = note.image
            if let modifiedDate = note.date {
                cell.dateLabel.text = "Modified: " + dateFormatter.string(from: modifiedDate)
            } else {
                cell.dateLabel.text = "unknown"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotoNoteViewController,
            let segueIdentifier = segue.identifier, segueIdentifier == "existingNote",
            let row = notesTableView.indexPathForSelectedRow?.row {
                    destination.note = notes[row]
        }
    }
    
    


}
