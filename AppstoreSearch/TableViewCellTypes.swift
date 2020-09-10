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
    
    @IBOutlet weak var screenshot_1: UIImageView!
    @IBOutlet weak var screenshot_2: UIImageView!
    @IBOutlet weak var screenshot_3: UIImageView!
}
