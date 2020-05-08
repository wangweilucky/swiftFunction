//
//  ViewController4.swift
//  swift Fuction
//
//  Created by wangwei on 5/7/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import UIKit

class ViewController6: UIViewController, ADProtocol {
    
    var adViewModel = ADViewModel()
    var adView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(adView)
        adStart()
    }
}

class ViewController7: UIViewController, ADProtocol {
    
    var adViewModel = ADViewModel()
    var adView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(adView)
        adStart()
    }
}

class MyView1: UIViewController, ADProtocol {
    
    var adViewModel = ADViewModel()
    var adView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
}

protocol ADProtocol {
    
    var adViewModel :ADViewModel { get set }
    var adView :UIView { get }
}

extension ADProtocol {
    
    func adStart() {
        adUpdate(success: { _ in
            
        }) { _ in
        }
    }
    
    func adUpdate(success: (ADModel)->(), falure: (String)->()) {
        adViewModel.getAdData()
        _ = adViewModel.adDataObservable.subscribe { state in
            state.adState(success: { adModel in
                // 更新视图
                self.adView.backgroundColor = UIColor.red
            }) { errorMessage in
                // 错误提示
            }
        }
    }
}
