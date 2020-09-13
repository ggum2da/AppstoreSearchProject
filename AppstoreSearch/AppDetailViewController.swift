//
//  AppDetailViewController.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/13.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit

class AppDetailViewController: UIViewController {
    
    var appData:AppDataModel?
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    
    @IBOutlet weak var infoScrBackView: UIView!
    @IBOutlet weak var infoScrView: UIScrollView!
    @IBOutlet weak var infoScrContentView: UIView!
    
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var agoLabel: UILabel!
    @IBOutlet weak var historyBtn: UIButton!
    
    @IBOutlet weak var releaseNoteLabel: UILabel!
    
    @IBOutlet weak var screenScrBackView: UIView!
    @IBOutlet weak var screenScrView: UIScrollView!
    @IBOutlet weak var screenScrContentView: UIView!
    var screenshotImgView:UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = appData?.trackName
        self.subTitleLabel.text = appData?.artistName
        self.versionLabel.text = appData?.version
        self.releaseNoteLabel.text = appData?.releaseNotes
        
        self.iconImageView.downloadImageWithLoad(imageUrl: appData?.artworkUrl512)
        
        if let urls = appData?.screenshotUrls {
            
            // 스크린샷 갯수 만큼 스크린샷 이미지 뷰 생성
            for url in urls {
                
                let x = screenshotImgView == nil ? 0 : attachViewHorizontal(from: screenshotImgView!)
                
                let imageView = UIImageView(frame: CGRect(x: x+20, y: 0, width: 220, height: 430))
                imageView.backgroundColor = .white
                imageView.layer.cornerRadius = 15
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                screenScrContentView.addSubview(imageView)
                
                imageView.downloadImageWithLoad(imageUrl: url)
                
                self.screenshotImgView = imageView
            }
            
            // 스크린샷 스크롤 컨텐츠 사이즈 세팅
            if let imageView = self.screenshotImgView {
                
                let width = attachViewHorizontal(from: imageView)+20
                self.screenScrContentView.snp.updateConstraints { (maker) in
                    maker.width.equalTo(width)
                }
            }
            
        }
        
    }
    
}
