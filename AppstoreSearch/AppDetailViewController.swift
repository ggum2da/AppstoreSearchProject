//
//  AppDetailViewController.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/13.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit

class AppDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appData:AppDataModel!
    
    // 메인 스크롤뷰, 컨텐츠 뷰
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainContentView: UIView!
    
    // 아이콘 이미지, 타이틀, 서브타이틀, 열기버튼
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // 평가 및 별점, 순위 및 카테고리, 연령
    @IBOutlet weak var infoBackView: UIView!
    @IBOutlet weak var avrRatingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var cateLabel: UILabel!
    
    @IBOutlet weak var contentAgeLabel: UILabel!
    
    // 버전
    @IBOutlet weak var versionLabel: UILabel!
    
    // 업데이트 내용
    @IBOutlet weak var releaseNoteLabel: UILabel!
    
    // 미리보기
    @IBOutlet weak var screenScrBackView: UIView!
    @IBOutlet weak var screenScrView: UIScrollView!
    @IBOutlet weak var screenScrContentView: UIView!
    var screenshotImgView:UIImageView?
    
    // 정보
    @IBOutlet weak var infoTableView: UITableView!
    var infoData:[[Any]]?
    
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
        
        // 하단 정보 데이터 세팅 및 테이블뷰 로드
        self.setInfoData()
        
        self.titleLabel.text = appData.trackName
        self.subTitleLabel.text = appData.artistName
        self.versionLabel.text = "버전 " + appData.version
        //self.openBtn.accessibilityIdentifier = String(appData.trackId)
        
        // 평균 평가 점수 및 별점
        let rating = round(appData.averageUserRating * 10) / 10
        self.avrRatingLabel.text = String(rating)
        let view = rateWithStar(frame: CGRect(x: 0, y: 0, width: 100, height: 25), rate: appData.averageUserRating)
        self.ratingView.addSubview(view)
        
        // 누적 평점
        self.ratingLabel.text = ratingNum(rate: Double(appData.userRatingCount)) + "개의 평가"
        
        // 카테고리
        self.cateLabel.text = appData.genres[0]
        
        // 연령
        self.contentAgeLabel.text = appData.trackContentRating
        
        // 업데이트 내용
        if appData.releaseNotes == "" {
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
        //self.descriptionView.moreBtn.accessibilityIdentifier = "descriptionView"
        
        // 앱 아이콘 및 스샷 이미지 폴더 이름 = trackId
        trackId = String(appData?.trackId ?? 0)
        
        // 앱 아이콘, 스크린샷 다운로드 및 로드
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
    
    func setInfoData() {
        DispatchQueue.global().async {
            guard let data = self.appData else { return }
            
            let b = Double(data.fileSizeBytes)
            let fileSizeStr = String(format: "%.01fMB", b! * 0.000001) // MB 치환
            
            let category = data.genres[0]
            
            self.infoData = [["제공자",data.artistName],
                             ["크기" ,fileSizeStr],
                             ["카테고리", category],
                             ["호환성", "iOS"+data.minimumOsVersion+"이상 필요"],
                             ["언어",data.languageCodesISO2A[0]],
                             ["연령 등급",data.trackContentRating],
                             ["저작권","©"+data.artistName]]
            
            DispatchQueue.main.async {
                self.infoTableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return infoData == nil ? 0 : infoData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        
        guard let data = infoData else { return UITableViewCell() }
        
        cell.textLabel?.text = data[indexPath.row][0] as? String
        cell.detailTextLabel?.text = data[indexPath.row][1] as? String
        
        return cell
    }
    
    
    //MARK: - Gesture Action
    @IBAction func tappedAction(_ sender: Any) {
        
        // ImageListViewController get
        let imageListViewController:ImageListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageListViewController") as! ImageListViewController

        // 선택한 Data set
        let imageList = appData.screenshotUrls
        imageListViewController.imageList = imageList
        imageListViewController.trackId = trackId

        self.navigationController?.pushViewController(imageListViewController, animated: true)
        
    }
    
    
    // MARK: - Button Action
    @objc func moreAction(sender:UIButton) {
        
        self.descriptionView.label.numberOfLines = 0
        
        sender.isHidden = true
        
    }
    
    // App open button
    @IBAction func openAction(sender:UIButton) {
        let id = String(appData.trackId)
        let url = String(format: APP_OPEN_URL, id)
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    // share app url
    @IBAction func shareAction(_ sender: Any) {
        
        let id = String(appData.trackId)
        let url = String(format: APP_OPEN_URL, id)
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
