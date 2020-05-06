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
    class func uploadStatisInfo(log dic: Dictionary<String, String>) {
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
                    StatUtility.uploadStatisInfo(log: ["videoTitle": videoTitle])
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
        _ = g(a: videoTitle, f: { (videoTitle) -> () in
            StatUtility.uploadStatisInfo(log: ["videoTitle": videoTitle])
        })
    }
    
    // 使用swift的特性简化
    // 这段代码没有使用任何的判断语句，但代码是安全的
    func statVideoPlay2(videoUrl: String?){
        let info: VideoInfo? = g(a: videoUrl) { self.videos[$0] }
        let videoTitle: String? = g(a: info) { $0.videoTitle }
        
        _ = g(a: videoTitle, f: { (videoTitle) -> () in
            StatUtility.uploadStatisInfo(log: ["videoTitle": videoTitle])
        })
    }

    // 因为接受的第一个参数都是optional，将此方法扩展到optional中
    // 改进下后，
    func statVideoPlay3(videoUrl: String?){
        _ = videoUrl
            .g(a: videoUrl) { self.videos[$0] }
        // 下不下去了...
    }
    
    // 使用optional的flatMap特性，来实现链式的调用
    func statVideoPlay4(videoUrl: String?){
        _ = videoUrl
            .g1 { self.videos[$0] }
            .g1 { $0.videoTitle }
            .g1(f: { (videoTitle) -> () in
                StatUtility.uploadStatisInfo(log: ["videoTitle": videoTitle])
            })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
        let xObservable = Observable(pure: 0)
        let yObservable = Observable(pure: 1)
        _ = xObservable.bind(signal: yObservable)
        
        _ = xObservable.subscribe { (x) in
            print("got \(x) in xObserable")
        }
        _ = yObservable.subscribe { (x) in
            print("got \(x) in yObserbale")
        }
         
        xObservable.update(3)
    }
}


extension Optional {
    // 接受一个可选参数a 和 一个接受非可选参数a并转成可选参数b的函数
    func g<T, E>(a: T?, f:(_ a: T)->(E?)) -> E? {
        guard let a = a else { return nil }
        return f(a)
    }
    
    func g1<b>(f: (Wrapped)-> b?) -> b? {
        return self.flatMap({ f($0) })
    }
}

func g<T, E>(a: T?, f:(_ a: T)->(E?)) -> E? {
    guard let a = a else { return nil }
    return f(a)
}

