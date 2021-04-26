//
//  Observable.swift
//  bucovat
//
//  Created by Arnold Mitricã on 17.03.2021.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }

    private var valueChanged: ((T) -> Void)?
    
    private var valuesChanged: [UUID:((T) -> Void)?]?
    
    private var viewModels:[CompanyViewModel] = [CompanyViewModel]()

    init(value: T) {
        self.value = value
    }

    /// Add closure as an observer and trigger the closure imeediately if fireNow = true
    func addObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
        valueChanged = onChange
        if fireNow {
            onChange?(value)
        }
    }
    
    func addAnotherObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
        
    }
    
//    func addObservers(fireNow: Bool = true, _ uuid:UUID, _ onChange: ((T) -> Void)?){
//        valuesChanged[uuid] = onChange
//        if fireNow {
//            onChange
//        }
//    }

    func removeObserver() {
        valueChanged = nil
    }

}

class MultiObservable{
//    private var uuid:
//    private var stateValue:Bool
//    private static var n
//    init(uuid:UUID,stateValue:Bool) {
//        self.uuid = uuid
//        self.stateValue = stateValue
//    }
//    func makeNewObservable(){
//
//    }
    init(){
        
    }
 //   static var newObservables:[NewObservable<UUID,Bool>]?
    var observables:[UniqueProfile:NewObservable<UUID,Bool>] = [:]
//    func addNewObserver(){
//        MultiObservable.newObservables?.append(newObsv!)
//    }
    func addNewObservable(uniqueProfile:UniqueProfile, newObsv:NewObservable<UUID,Bool>){
        observables[uniqueProfile] = newObsv
    }
    
    deinit {
        print("MultiObservable deinitialized")
    }
    
}

struct UniqueProfile:Hashable{
    let email:String
    let user:String
}

class NewObservable<K:Hashable, T> {
    
    
    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                //self.valuesChanged[self.key]!()
                guard let strongSelf = self else { return }
//                for i in strongSelf.valuesChanged.values{
//                    if let closure = strongSelf.valuesChanged[i.key]{
//                        closure?()
//                    }
//                }
                //strongSelf.valuesChanged.keys.map({ strongSelf.valuesChanged[$0]!!() })
                strongSelf.valuesChanged.keys.forEach { strongSelf.valuesChanged[$0]!!()
                }
            }
        }
    }
    
    var key: K

    
    private var valuesChanged: [K:(() -> Void)?] = [:]
    

    init(key: K, value: T) {
        self.value = value
        self.key = key
    }

    /// Add closure as an observer and trigger the closure imeediately if fireNow = true
    
    func addAnotherObserver(fireNow: Bool = true, _ onChange: (() -> Void)?, for key:K) {
        valuesChanged[key] = onChange
        if fireNow{
            onChange?()
        }
    }
    

    func removeObserver() {
        //valuesChanged = nil
    }

}


