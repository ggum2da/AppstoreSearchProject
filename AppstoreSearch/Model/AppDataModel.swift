//
//  AppDataModel.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/12.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation

struct AppDataModel: Codable {
    
    var trackName:String            // 타이틀
    var sellerName:String           // 회사이름
    var artworkUrl100:String        // 아이콘 이미지 100*100
    var artworkUrl512:String        // 아이콘 이미지 512*512
    var averageUserRating:Double    // 평균 점수
    var trackContentRating:String   // 연령 등급
    var fileSizeBytes:String        // 파일크기
    var releaseNotes:String         // 업데이트 안내
    var formattedPrice:String       //
    var minimumOsVersion:String     // 호환성
    var artistName:String           // 개발자
    var price:Double                // 가격
    var description:String          // 앱 설명
    var version:String              // 앱 버전
    var userRatingCount:Int         // 유저 평가
    var trackId:Int                 // trackId
    
    var genres:[String]             // 카테고리
    var screenshotUrls:[String]     // 스크린샷
    var languageCodesISO2A:[String] // 언어
    var bundleId:String             // 번들 ID
    
    var currentVersionReleaseDate:String // 현재버전 릴리즈한 시간
    
//    init(from decoder: Decoder) throws {
//        genres = try decoder.singleValueContainer().decode([String].self)
//        screenshotUrls = try decoder.singleValueContainer().decode([String].self)
//        languageCodesISO2A = try decoder.singleValueContainer().decode([String].self)
//    }
}

/*
class AppDataModel: NSObject {
    
    static let shared : AppDataModel = { let instance = AppDataModel(); return instance }()
    
    var trackName:String?           // 타이틀
    var artworkUrl100:String?       // 아이콘 이미지 100*100
    var averageUserRating:String?   // 평균 점수
    
    var screenshotUrls:[String]?    // 스크린샷

    var languageCodesISO2A:[String]? // 언어
    var trackContentRating:String?  // 연령 등급
    var fileSizeBytes:String?       // 파일크기

    var releaseNotes:String?        // 업데이트 안내
    var formattedPrice:String?      //
    var minimumOsVersion:String?
    var artistName:String?          // 개발자
    var genres:String?
    var price:String?               // 가격
    var appDescription:String?      // 앱 설명
    var version:String?             // 앱 버전
    var userRatingCount:String?     // 유저 평가
    
}
*/
