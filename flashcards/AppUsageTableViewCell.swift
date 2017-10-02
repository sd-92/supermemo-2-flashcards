//
//  AppUsageTableViewCell.swift
//  flashcards
//
//  Created by Simone De Luca on 31/03/2017.
//  Copyright © 2017 Simone De Luca. All rights reserved.
//

import UIKit

class AppUsageTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
