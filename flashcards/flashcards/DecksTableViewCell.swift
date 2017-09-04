//
//  DecksTableViewCell.swift
//  flashcards
//
//  Created by Simone De Luca on 26/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//

import UIKit

class DecksTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var disclosure: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
