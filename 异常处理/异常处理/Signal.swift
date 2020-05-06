//
//  File.swift
//  异常处理
//
//  Created by wangwei on 5/6/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation

class Signal<T>: NSObject {
    
    typealias SignalToken = Int
    typealias Subscriber = (T) -> Void
    
    var tokenCounter :Int = 0
    internal private(set) var value : T?
    var subscribers :Dictionary = [SignalToken: Subscriber]()
    
    let queue = DispatchQueue(label: "com.swift.signal.token")
    
    init(value: T) {
        self.value = value
    }
    
    func subscribe(subscriber: @escaping Subscriber) -> SignalToken {
        let token = signalNextToken()
        subscribers.updateValue(subscriber, forKey: token)
        return token
    }
    
    func bind(signal: Signal) -> SignalToken {
        // 将两个Signal进行绑定
        return 1
    }
    
    func update(_ value: T) {
        _ = subscribers.compactMap { $1(value) }
    }
    
    func signalNextToken() -> Int {
        return tokenCounter + 1
    }
    
}
