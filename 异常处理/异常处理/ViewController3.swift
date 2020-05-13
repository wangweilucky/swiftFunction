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
    
    var onClickObservableObservable = Observable<Bool>(pure: false)
    
    
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
        
        _ = onClickObservableObservable  // onClick Observable
            .flatNext(f: { state -> Observable<Int> in // time Observable
                print("button click")
                self.initState()
                let timeOb = Observable(pure: 5)
                // 倒计时操作
                return timeOb
            })
            .filter(f: { (time) -> Bool in
                return time<=0 ? true : false
            })
            .map { $0 == 0 }
            .flatNext(f: { (canrequest) -> Observable<String> in // requsetFinish Observable
                self.requestL.text = "网络请求中..."
                let requsetFinishOb = Observable(pure: "")
                // 异步网络请求
                return requsetFinishOb
            })
            .filter { !$0.isEmpty } // 网络请求是否成功
            .flatNext(f: { result -> Observable<String> in  //  requsetResult Observable
                let requsetResultOb = Observable(pure: "")
                return requsetResultOb
            }).subscribe { print( "打印log: \($0)")}
        onClickObservableObservable.update(true)
    }
}
