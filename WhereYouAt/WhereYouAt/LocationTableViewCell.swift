//
//  LocationTableViewCell.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/6/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet var locationName: UILabel!
    @IBOutlet var typeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
