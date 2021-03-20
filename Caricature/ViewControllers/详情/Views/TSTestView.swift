//
//  TSTestView.swift
//  Caricature
//
//  Created by Qincc on 2021/3/15.
//

import UIKit


class TSTestView: UIView {
    var label = UILabel.init()
    var button = UIButton.init()
    
    let bag = DisposeBag.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func test1() -> Void {
        let observable = Observable<Int>.timer(.seconds(2), period: .seconds(1), scheduler: MainScheduler.instance)
        let binder = Binder<Bool>.init(button) { (button, value) in
            button.isHidden = value
        }
        //一下两种写法都是对的
        observable.map { (value) -> Bool in
            return value % 2 == 0
        }.bind(to: binder).disposed(by: bag)
        
        observable.map { (value) -> Bool in
            return value % 2 == 0
        }.bind(to: self.button.rx.isHidden).disposed(by: bag)
    }
    
    
    func test() -> Void {
        let binder = Binder.init(label, scheduler: MainScheduler.init()) { (label, value) in
            label.text = value
        }
        
        //下面的三种写法等价
        Observable.just("1").subscribe(binder).dispose()
        let _ = Observable.just("1").takeUntil(self.rx.deallocated).subscribe(binder)
        Observable.just("1").bind(to: binder).dispose()
    }
    
    func test2() -> Void {
        let observable = Observable<Int>.create { (oberber) -> Disposable in
            //进行网络请求
            
            return Disposables.create()
        }
        
        observable.subscribe { (events) in
            switch events {
            case .next(let value):
                print(value)
            case.completed:
                print("complete")
            case .error(let error):
                print(error)
            }
        }.dispose()
    }
}
