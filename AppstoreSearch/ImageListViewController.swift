//
//  ImageListViewController.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/14.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit

class ImageListViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    var imageList = [String]()
    var trackId = String()
    var screenshotImgView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스크린샷 갯수 만큼 스크린샷 이미지 뷰 생성
        var i = 0
        for url in imageList {
            
            let x = screenshotImgView == nil ? 0 : attachViewHorizontal(from: screenshotImgView!)+15
            
            let imageView = UIImageView(frame: CGRect(x: x+15, y: 20, width: self.view.bounds.width-30, height: self.view.bounds.height-40))
            imageView.backgroundColor = .white
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            contentView.addSubview(imageView)
            
            imageView.downloadScreenshot(imageUrl: url, id: trackId, tag: i)
            
            self.screenshotImgView = imageView
            
            i += 1
        }
        
        // 스크린샷 스크롤 컨텐츠 사이즈 세팅
        if let imageView = self.screenshotImgView {
            
            let width = attachViewHorizontal(from: imageView)+15
            self.contentView.snp.updateConstraints { (maker) in
                maker.width.equalTo(width)
            }
        }
        
    }
    
    
    
}
