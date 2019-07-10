//
//  PhotoNotesTableViewCell.swift
//  PhotoNotes
//
//  Created by Felipe Costa on 7/5/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit

class PhotoNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var notesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
