//
//  TrendTableViewCell.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/13/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class TrendTableViewCell: UITableViewCell {

    @IBOutlet var typeImage: UIImageView!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
