//
//  AppDelegate.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/09.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 저장된 날짜와 오늘 날짜가 다르면 다운로드 받은 이미지 삭제
        let savedDate = UserDefaults.standard.value(forKey: "savedDate") as? String
        
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let todayString = dateFormatter.string(from: todayDate)
        
        if savedDate != todayString {
            // tmp Directory Delete
            try? FileManager.default.removeItem(atPath: NSTemporaryDirectory())
        }
        
        UserDefaults.standard.set(todayString, forKey: "savedDate")
        UserDefaults.standard.synchronize()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

let APP_OPEN_URL = "itms-apps://itunes.apple.com/app/apple-store/%@?mt=8"

// MARK: - ratingView
func rateWithStar(frame:CGRect, rate:Double) -> UIView {

    let view = UIView(frame: frame)//CGRect(x: 0, y: 0, width: 60, height: 21))
    
    let fullCount = 5
    let fullStarCount = floor(rate)
    let halfStarWidth = round((rate-fullStarCount) * 100) / 100
    //let emptyStarCount = floor(Double(fullCount) - fullStarCount - halfStarWidth)
    
    let fullStar = UIImage(named: "fullStar")
    let emptyStar = UIImage(named: "emptyStar")
    
    var star = UIImageView()
    
    var image = UIImage()
    
    //let width = frame.size.width/5
    let height = frame.size.height-10
    let gapMargin = floor(height/5)
    
    // fullStar와 emptyStar를 그려준다
    for i in 0..<fullCount {
        if i < Int(fullStarCount) {
            image = fullStar!
        }else {
            image = emptyStar!
        }
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: attachViewHorizontal(from: star)+gapMargin, y: 5, width: height, height: height)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemGray4
        view.addSubview(imageView)

        imageView.tag = 100+i
        
        star = imageView
    }
    
    // halfStar가 이미지를 emptyStar 위에 덮어준다
    if let emptyStarImageView = view.viewWithTag(100+Int(fullStarCount)) {
        
        let offsetX = emptyStarImageView.frame.origin.x
        
        let halfStarImageView = UIImageView(image: fullStar)
        halfStarImageView.frame = CGRect(x: offsetX, y: 5, width: height, height: height)
        halfStarImageView.image = halfStarImageView.image?.withRenderingMode(.alwaysTemplate)
        halfStarImageView.tintColor = .systemGray4
        view.addSubview(halfStarImageView)

        let mask = CALayer()
        mask.contents = fullStar
        mask.frame = CGRect(x: 0, y: 0, width: height*CGFloat(halfStarWidth), height: height)
        mask.backgroundColor = UIColor.black.cgColor
        halfStarImageView.layer.mask = mask
        halfStarImageView.layer.masksToBounds = true
    }
    
    return view

}

func ratingNum(rate:Double) -> String {
    
    var ratingCount = rate
    
    var ratingStr = String(format: "%.0f", ratingCount)
    if ratingCount > 10000 {
        ratingCount = ratingCount/10000
        ratingStr = String(format: "%.1f만", ratingCount)
    }else if ratingCount > 1000 {
        ratingCount = ratingCount/1000
        ratingStr = String(format: "%.1f천", ratingCount)
    }
    
    return ratingStr
}

// MARK: - View 이어붙이기
func attachViewHorizontal(from view:UIView) -> CGFloat {
    return view.frame.origin.x + view.frame.size.width
}

func attachViewVertical(from view:UIView) -> CGFloat {
    return view.frame.origin.y + view.frame.size.height
}
