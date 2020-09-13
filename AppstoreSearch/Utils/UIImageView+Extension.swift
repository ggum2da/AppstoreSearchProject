//
//  UIImageView+Extension.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/11.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func downloadImageData(from url:URL, completion:@escaping(Data?, URLResponse?, Error?) -> ()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public func downloadImageWithLoad(imageUrl:String?) {
        
        DispatchQueue.global().async {
            
            let url = URL(string: imageUrl ?? "")
            
            self.downloadImageData(from: url!) { (data, response, error) in
                
                if error == nil && data != nil {
                    
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data!)
                        
                        self.isHidden = false
                    }
                    
                }else{
                    print("image download fail === \(error.debugDescription)")
                }
                
            }
        }
        
    }
}
