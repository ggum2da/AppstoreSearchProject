//
//  DescriptionView.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/13.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit

class DescriptionView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        
        let view = Bundle.main.loadNibNamed("DescriptionView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
