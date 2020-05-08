//
//  ViewController2.swift
//  异常处理
//
//  Created by wangwei on 5/7/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let xObservable = Observable(pure: 0)
        let yObservable = Observable(pure: 1)
        _ = xObservable.bind(yObservable)
        
        _ = xObservable.subscribe { (x) in
            print("got \(x) in xObserable")
        }
        _ = yObservable.subscribe { (x) in
            print("got \(x) in yObserbale")
        }
        
        xObservable.update(3)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
