//
//  TableViewCellTypes.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/10.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit

class defaultCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
}

class filteredCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
}

class previewCell: UITableViewCell {
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var screenshot_1: UIImageView!
    @IBOutlet weak var screenshot_2: UIImageView!
    @IBOutlet weak var screenshot_3: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        appIcon.isHidden = true; appIcon.image = nil
        
        screenshot_1.isHidden = true; screenshot_1.image = nil
        screenshot_2.isHidden = true; screenshot_2.image = nil
        screenshot_3.isHidden = true; screenshot_3.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        appIcon.layer.borderColor = UIColor(displayP3Red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        
        screenshot_1.layer.borderColor = UIColor(displayP3Red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        screenshot_2.layer.borderColor = UIColor(displayP3Red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
        screenshot_3.layer.borderColor = UIColor(displayP3Red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).cgColor
    }
}
