//
//  ViewController3.swift
//  异常处理
//
//  Created by wangwei on 5/7/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var requestL: UILabel!
    @IBOutlet weak var resultL: UILabel!
    
    var timeCountObservable = Observable<Bool>(pure: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initState()
        
    }
    
    func initState() {
        timeL.text = "倒计时：5"
        requestL.text = "尚未请求"
        resultL.text = "请求结果未知"
    }
    
    @IBAction func action(_ sender: Any) {
        timeCountObservable = Observable(pure: true)  // onClick Observable
        timeCountObservable
            .flatNext(f: { state -> Observable<Int> in // time Observable
                print("button click")
                self.initState()
                let timeOb = Observable(pure: 5)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if let value = timeOb.value , (value-1) >= 0 {
                        timeOb.update(value-1)
                    }
                }
                return timeOb
            })
            .filter(f: { (time) -> Bool in // 对time进行过滤
                if time >= 0 {
                    self.timeL.text = "倒计时：\(time)"
                }
                return time<=0 ? true : false
            })
            .map { $0 == 0 } // 是否倒计时结束 Observable
            .flatNext(f: { (canrequest) -> Observable<String> in // 是否网络请求结束 Observable
                self.requestL.text = "网络请求中..."
                let requsetFinishOb = Observable(pure: "")
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 4) {
                    DispatchQueue.main.async {
                        requsetFinishOb.update("hello world！")// 请求成功
                    }
                }
                return requsetFinishOb
            })
            .filter { !$0.isEmpty } // 网络请求是否成功
            .flatNext(f: { result -> Observable<String> in  // 请求成功 Observable
                let requsetResultOb = Observable(pure: "")
                self.requestL.text = "网络请求成功"
                self.resultL.text = result
                requsetResultOb.update("请求成功" )
                return requsetResultOb
            }).subscribe { print( "打印log: \($0)")}
        timeCountObservable.update(true)
    }
}
