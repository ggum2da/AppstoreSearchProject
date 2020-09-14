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
    
    // 메인 스크롤뷰, 컨텐츠 뷰
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainContentView: UIView!
    
    // 아이콘 이미지, 타이틀, 서브타이틀, 열기버튼
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var openBtn: UIButton!
    
    // 평가 및 별점, 순위 및 카테고리, 연령
    @IBOutlet weak var infoBackView: UIView!
    @IBOutlet weak var avrRatingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var cateLabel: UILabel!
    
    @IBOutlet weak var contentAgeLabel: UILabel!
    
    // 버전, 시간, 버전 기록 버튼
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var agoLabel: UILabel!
    @IBOutlet weak var historyBtn: UIButton!
    
    // 업데이트 내용
    @IBOutlet weak var releaseNoteLabel: UILabel!
    
    // 미리보기
    @IBOutlet weak var screenScrBackView: UIView!
    @IBOutlet weak var screenScrView: UIScrollView!
    @IBOutlet weak var screenScrContentView: UIView!
    var screenshotImgView:UIImageView?
    
    @IBOutlet weak var descriptionView: DescriptionView!
    
    var trackId = ""
    
    // MARK: -
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
        self.openBtn.accessibilityIdentifier = String(appData?.trackId ?? 0)
        
        // 평균 평가 점수 및 별점
        let rating = round(appData!.averageUserRating * 10) / 10
        self.avrRatingLabel.text = String(rating)
        let view = rateWithStar(frame: CGRect(x: 0, y: 0, width: 100, height: 25), rate: appData?.averageUserRating ?? 0)
        self.ratingView.addSubview(view)
        
        // 누적 평점
        self.ratingLabel.text = ratingNum(rate: Double(appData?.userRatingCount ?? 0))+"개의 평가"
        
        // 앱 순위 및 카테고리
        
        
        // 연령
        
        
        // 업데이트 내용
        if appData?.releaseNotes == nil || appData?.releaseNotes == "" {
            
            self.releaseNoteLabel.isHidden = true
            self.releaseNoteLabel.snp.updateConstraints { (maker) in
                maker.height.equalTo(1)
            }
        }else{
            self.releaseNoteLabel.text = appData?.releaseNotes
        }
        
        
        // 앱 소개 내용
        self.descriptionView.label.text = appData?.description
        self.descriptionView.moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        self.descriptionView.moreBtn.accessibilityIdentifier = "descriptionView"
        
        trackId = String(appData?.trackId ?? 0)
        
        self.iconImageView.downloadAppIcon(imageUrl: appData?.artworkUrl512, id: trackId)
        
        if let urls = appData?.screenshotUrls {
            
            // 스크린샷 갯수 만큼 스크린샷 이미지 뷰 생성
            var i = 0
            for url in urls {
                
                let x = screenshotImgView == nil ? 0 : attachViewHorizontal(from: screenshotImgView!)
                
                let imageView = UIImageView(frame: CGRect(x: x+15, y: 0, width: 300, height: 550))
                imageView.backgroundColor = .white
                imageView.layer.cornerRadius = 15
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                screenScrContentView.addSubview(imageView)
                
                imageView.downloadScreenshot(imageUrl: url, id: trackId, tag: i)
                
                self.screenshotImgView = imageView
                
                i += 1
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
    
    
    // MARK: - Button Action
    @objc func moreAction(sender:UIButton) {
        
        if sender.accessibilityIdentifier == "descriptionView" {
            self.descriptionView.label.numberOfLines = 0
        }else{
            self.releaseNoteLabel.numberOfLines = 0
        }
        
        sender.isHidden = true
        
    }
    
    // MARK: - Button Action
    @IBAction func openAction(sender:UIButton) {
        let id = String(sender.accessibilityIdentifier!)
        let url = String(format: APP_OPEN_URL, id)
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
}
