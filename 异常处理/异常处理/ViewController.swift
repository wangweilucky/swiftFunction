//
//  ViewController.swift
//  异常处理
//
//  Created by wangwei on 5/6/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import UIKit

class VideoInfo {
    var videoTitle: String?
    var videoCategory: String?
}

class StatUtility {
    class func uploadInfo(log dic: Dictionary<String, String>) {
        print("update log")
    }
}

class ViewController: UIViewController {
    
    var videos: Dictionary<String,VideoInfo>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 用swift的方式书写
    func statVideoPlay(videoUrl: String?) {
        if let videoUrl = videoUrl {
            let videoInfo = self.videos[videoUrl]
            if let info = videoInfo {
                if let videoTitle = info.videoTitle {
                    StatUtility.uploadInfo(log: ["videoTitle": videoTitle])
                }
                if let videoCategory = info.videoCategory {
                    StatUtility.uploadInfo(log: ["videoCategory": videoCategory])
                }
            }
        }
    }
    
    // 使用模板函数后
    func statVideoPlay1(videoUrl: String?){
        let info: VideoInfo? = g(a: videoUrl) { (a) -> (VideoInfo?) in
            return self.videos[a]
        }
        let videoTitle: String? = g(a: info) { (info) -> (String?) in
            return info.videoTitle
        }
        
        let videoCategory: String? = g(a: info) { (info) -> (String?) in
            return info.videoCategory
        }
        
        _ = g(a: videoTitle, f: { (videoTitle) -> () in
            StatUtility.uploadInfo(log: ["videoTitle": videoTitle])
        })
        _ = g(a: videoCategory, f: { (videoCategory) -> () in
            StatUtility.uploadInfo(log: ["videoCategory": videoCategory])
        })
    }
    
    // 使用swift的特性简化
    // 这段代码没有使用任何的判断语句，但代码是安全的
    func statVideoPlay2(videoUrl: String?){
        let info: VideoInfo? = g(a: videoUrl) { self.videos[$0] }
        let videoTitle: String? = g(a: info) { $0.videoTitle }
        let videoCategory: String? = g(a: info) { $0.videoCategory }
        
        _ = g(a: videoTitle) { StatUtility.uploadInfo(log: ["videoTitle": $0])}
        _ = g(a: videoCategory) { StatUtility.uploadInfo(log: ["videoCategory": $0])}
    }
    
    // 因为接受的第一个参数都是optional，将此方法扩展到optional中
    func statVideoPlay3(videoUrl: String?){
        _ = videoUrl
            .g { self.videos[$0] }
            .g { $0.videoTitle }
            .g { StatUtility.uploadInfo(log: ["videoTitle": $0])}
        
        _ = videoUrl
            .g { self.videos[$0] }
            .g { $0.videoCategory }
            .g { StatUtility.uploadInfo(log: ["videoCategory": $0])}
    }
    
    // 使用optional的flatMap特性，并且通过flatMap过滤掉空值
    func statVideoPlay4(videoUrl: String?){
        _ = videoUrl
            .flatMap { self.videos[$0] }
            .flatMap { $0.videoTitle }
            .flatMap { StatUtility.uploadInfo(log: ["videoTitle": $0]) }
        
        _ = videoUrl
            .flatMap { self.videos[$0] }
            .flatMap { $0.videoCategory }
            .flatMap { StatUtility.uploadInfo(log: ["videoCategory": $0])}
    }
}


extension Optional {
    
    func g<T>(f: (Wrapped)->(T?)) -> T? {
        guard let WrappedSelf = self else { return nil }
        return f(WrappedSelf)
    }
    
    func g1<T>(f: (Wrapped)-> T?) -> T? {
        return self.flatMap({ f($0) })
    }
}

func g<T, E>(a: T?, f:(_ a: T)->(E?)) -> E? {
    guard let a = a else { return nil }
    return f(a)
}

