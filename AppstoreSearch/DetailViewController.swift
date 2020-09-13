//
//  DetailViewController.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/12.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var appData:AppDataModel?
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseNotesLabel: UILabel!
    
    @IBOutlet weak var infoScrBackView: UIView!
    let infoScrollView = UIScrollView()
    
    @IBOutlet weak var screenshotBackView: UIView!
    let screenshotScrollView = UIScrollView()
    
    
    var screenshotImageView:UIImageView?
    
    
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
        self.releaseNotesLabel.text = appData?.releaseNotes
        
        self.iconImgView.downloadImageWithLoad(imageUrl: appData?.artworkUrl512)
        
        // 앱 정보 스크롤뷰
        infoScrBackView.addSubview(infoScrollView)
//        infoScrollView.snp.makeConstraints { (maker) in
//            maker.leading.equalToSuperview()
//            maker.top.equalToSuperview()
//            maker.trailing.equalToSuperview()
//            maker.bottom.equalToSuperview()
//
//        }
        
        // 스크린샷 스크롤뷰
        screenshotBackView.addSubview(screenshotScrollView)
//        screenshotScrollView.snp.makeConstraints { (maker) in
//            maker.leading.equalToSuperview()
//            maker.top.equalToSuperview()
//            maker.trailing.equalToSuperview()
//            maker.bottom.equalToSuperview()
//        }
        
        if let urls = appData?.screenshotUrls {
            
            // 스크린샷 갯수 만큼 스크린샷 이미지 뷰 생성
            for url in urls {
                
                let x = screenshotImageView == nil ? 0 : attachViewHorizontal(from: screenshotImageView!)
                
                let imageView = UIImageView(frame: CGRect(x: x+20, y: 0, width: 220, height: 430))
                imageView.layer.cornerRadius = 15
                screenshotScrollView.addSubview(imageView)
                
                imageView.downloadImageWithLoad(imageUrl: url)
                
                self.screenshotImageView = imageView
            }
            
            // 스크린샷 스크롤 컨텐츠 사이즈 세팅
            if let imageView = self.screenshotImageView {
                screenshotScrollView.contentSize = CGSize(width: attachViewHorizontal(from: imageView), height: screenshotScrollView.bounds.size.height)
            }
            
        }
    }
}

class DetailNavigationBar: UINavigationBar {
    
}
