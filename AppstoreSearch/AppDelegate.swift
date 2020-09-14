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

func attachViewHorizontal(from view:UIView) -> CGFloat {
    return view.frame.origin.x + view.frame.size.width
}

func attachViewVertical(from view:UIView) -> CGFloat {
    return view.frame.origin.y + view.frame.size.height
}
