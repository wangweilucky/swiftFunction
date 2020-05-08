//
//  File.swift
//  异常处理
//
//  Created by wangwei on 5/6/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation

class Observable<T>: NSObject {
    
    typealias ObservableToken = Int
    typealias Subscriber = (T) -> Void
    
    var tokenCounter :Int = 0
    internal private(set) var value : T?
    var subscribers :Dictionary = [ObservableToken: Subscriber]()
    
    let queue = DispatchQueue(label: "com.swift.signal.token")
    
    deinit {
        print("干掉了")
    }
    
    init(pure value: T?) {
        self.value = value
    }
    
    func subscribe(subscriber: @escaping Subscriber) -> ObservableToken {
        let token = observableToken()
        subscribers.updateValue(subscriber, forKey: token)
        return token
    }
    
    func update(_ value: T) {
        self.value = value
        _ = subscribers.compactMap { $1(value) }
    }

    func observableToken() -> Int {
        tokenCounter = tokenCounter + 1
        return tokenCounter
    }
    
}

extension Observable {

    func bind(_ signal: Observable) -> ObservableToken {
        return self.subscribe { x in
            signal.update(x)
        }
    }

    func flatNext<B>(f: @escaping (T)-> Observable<B>) -> Observable<B> {
        let observable: Observable<B> = Observable<B>(pure: nil)
        _ = self.subscribe(subscriber: { (x) in
            let newObservable = f(x)
            observable.update(newObservable.value!)
            _ = newObservable.bind(observable)
        })
        return observable
    }
    
}


extension Observable {
   
    func map<B>(f: @escaping (T) -> B) -> Observable<B> {
        let mapObservable = Observable<B>(pure: nil)
        _ = self.subscribe(subscriber: { x in
            mapObservable.update(f(x))
        })
        return mapObservable
    }
    
    func filter(f: @escaping (T) -> Bool) -> Observable<T> {
        let filterObservable = Observable<T>(pure: self.value)
        _ = self.subscribe { x in
            if f(x) {
                filterObservable.update(x)
            }
        }
        return filterObservable
    }
}
