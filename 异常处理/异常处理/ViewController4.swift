//
//  ViewController4.swift
//  swift Fuction
//
//  Created by wangwei on 5/7/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import UIKit

class ViewController4: UIViewController {
    
    var adViewModel = ADViewModel()
    var adView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(adView)
        
        _ = adViewModel.adDataObservable.subscribe { state in
            state.adState(success: { adModel in
                // 更新视图
                self.adView.backgroundColor = UIColor.red
            }) { errorMessage in
                // 错误提示
            }
        }
        adViewModel.getAdData()
    }
}

class ViewController5: UIViewController {
    
    let adViewModel = ADViewModel()
    var adView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(adView)
        
        _ = adViewModel.adDataObservable.subscribe { state in
            state.adState(success: { adModel in
                // 更新视图
                self.adView.backgroundColor = UIColor.red
            }) { errorMessage in
                // 错误提示
            }
        }
        adViewModel.getAdData()
    }
}

class MyView: UIView {
    
    let adViewModel = ADViewModel()
    var adView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
}

class ADViewModel: NSObject {
    
    enum ADNetWorkState {
        case success(ADModel)
        case falure(String)
        case noknow(String)
        
        func adState(success: (ADModel)->(), falure: (String)->()) {
            switch self {
            case .success(let adModel):
                success(adModel)
            default:
                falure("Network Error")
            }
        }
    }
    
    let adDataObservable = Observable(pure: ADNetWorkState.noknow("未知状态"))
    
    override init() {
        super.init()
    }
    
    func getAdData() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 4) {
            DispatchQueue.main.async {
                self.adDataObservable.update(.success(ADModel(title: "滴滴滴！", message: "dididi")))// 请求成功
            }
        }
    }
    
}

struct ADModel {
    var title :String?
    var message :String?
}
