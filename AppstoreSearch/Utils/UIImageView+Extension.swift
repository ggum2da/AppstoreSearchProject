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
    
    // 앱 아이콘 다운로더
    func downloadAppIcon(imageUrl:String?, id:String) {
        
        let dirPath = NSTemporaryDirectory()+"\(id)/"
        
        if !FileManager.default.fileExists(atPath:dirPath) {
            try! FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: [:])
        }
        
        guard let fileName = URL(string: imageUrl!)?.lastPathComponent else { return }
        let filePath = dirPath+fileName
        
        self.downloadImageWithLoad(imageUrl: imageUrl, id: id, localPath: filePath)
    }
    
    // 스크린샷 다운로더
    func downloadScreenshot(imageUrl:String?, id:String, tag:Int) {
        
        let dirPath = NSTemporaryDirectory()+"\(id)/screenshots/"
        
        if !FileManager.default.fileExists(atPath:dirPath) {
            try! FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: [:])
        }
        
        //let componentUrl = (URL(string: imageUrl!)?.deletingLastPathComponent().lastPathComponent)!+"_\(tag)"
        //let split = componentUrl?.split(separator: "_").filter({ $0.contains("screenshot") })
        
        
        guard let fileName = (URL(string: imageUrl!))?.deletingPathExtension().lastPathComponent else { return }
        let filePath = dirPath+fileName+"_\(tag).png"
        
        self.downloadImageWithLoad(imageUrl: imageUrl, id: id, localPath: filePath)
        
    }
    
    // 데이터 통신
    func downloadImageData(from url:URL, completion:@escaping(Data?, URLResponse?, Error?) -> ()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // 다운로드 및 저장
    public func downloadImageWithLoad(imageUrl:String?, id:String, localPath:String) {

        DispatchQueue.global().async {
            
            if FileManager.default.fileExists(atPath: localPath) {
                DispatchQueue.main.async {
                    
                    self.image = UIImage(contentsOfFile: localPath)
                    
                    self.isHidden = false
                }
            }else{
                let url = URL(string: imageUrl ?? "")
                
                self.downloadImageData(from: url!) { (data, response, error) in
                    
                    if error == nil && data != nil {
                        
                        do {
                            try data!.write(to: URL(fileURLWithPath: localPath))
                            //print("write success === \(localPath)")
                        } catch {
                            print("write fail === \(error)")
                        }
                        
                        DispatchQueue.main.async {
                            self.image = UIImage(data: data!)
                            self.isHidden = false
                        }
                        
                    }else{
                        print("Download fail === \(error.debugDescription)")
                    }
                }
            }
        }
    }
}
