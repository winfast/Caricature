//
//  CTSubscriberViewModel.swift
//  Caricature
//
//  Created by Qincc on 2021/3/3.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class CTSubsciberCellViewModel: NSObject {
    @objc dynamic  var name: String?
    @objc dynamic var cover: String?
    @objc dynamic var comicId: Int = 0
    var tags: String?
    
    let bag = DisposeBag.init()
    
    @objc dynamic fileprivate var model: CTSubscriberItemModel?
    
    init(model: CTSubscriberItemModel) {
        self.model = model
        super.init()
        self.bindSignals();
    }
    
    func bindSignals() -> Void {
        self.rx.observeWeakly(Int.self, "model.comicId").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.comicId = value ?? 0;
        }).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "model.name").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.name = value;
        }).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "model.cover").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.cover = value;
        }).disposed(by: bag)
    }
}

class CTSubsciberSectionViewModel: NSObject {
    var maxSize: Int = 0
    var descriptionValue: String?
    var newTitleIconUrl: String?
    @objc dynamic var titleIconUrl: String?
    @objc dynamic var comics: [CTSubsciberCellViewModel]?
    @objc dynamic var itemTitle: String?
    var argValue: String?
    var canMore: Int = 0
    var argName: String?
    
    let bag = DisposeBag.init()
    
    @objc dynamic fileprivate var model: CTSubscriberModel?
    
    init(model: CTSubscriberModel) {
        self.model = model;
        super.init()
        self.bindSignals();
    }
    
    func bindSignals() -> Void {
        self.rx.observeWeakly(Array<CTSubscriberItemModel>.self, "model.comics").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.comics = value?.map({ (item: CTSubscriberItemModel) -> CTSubsciberCellViewModel in
                return CTSubsciberCellViewModel.init(model: item)
            });
        }).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "model.itemTitle").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.itemTitle = value;
        }).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "model.titleIconUrl").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.titleIconUrl = value;
        }).disposed(by: bag)
        
        
        self.rx.observeWeakly(String.self, "model.argValue").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.argValue = value;
        }).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "model.argName").subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            weakself.argName = value;
        }).disposed(by: bag)
    }
}

class CTSubscriberViewModel: NSObject {
    @objc dynamic open var dataSource: [CTSubsciberSectionViewModel]?

    //static let share = CTHomeNetworkManager.init()
    private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)
    
    func subscribeList() -> Observable<Void?> {
        return Observable<Void?>.create { (observable) -> Disposable in
            self.provider.request(.subscribeList, callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
                switch response {
                case let .success(result):
                    self?.paramSubscribeListData(result.data)
                    observable.onNext(nil)
                    observable.onCompleted()
                case let .failure(error):
                    observable.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    func paramSubscribeListData(_ data: Any) -> Void {
        let json = JSON.init(data)
        let dicts: [String: Any]? = json.dictionaryObject
        let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
        let stateCode : Int? = dataDict?["stateCode"] as? Int
        if stateCode == nil || stateCode != 1 {
            return
        }
        
        let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
        print(returnDataDict?.description);
        let subscribeList : [Any]? = returnDataDict?["newSubscribeList"] as? [Any]
        
        let comicListsModel : [CTSubscriberModel]? = subscribeList?.filter({ (item) -> Bool in
            let temp : [String:Any]? = item as? [String :Any];
            guard let _ = temp else {
                return false
            }
            return true
        }).map({ (item) -> CTSubscriberModel in
            return CTSubscriberModel.init(item as! [String : Any])
        })
        
        self.dataSource = comicListsModel?.map({ (item) -> CTSubsciberSectionViewModel in
            return CTSubsciberSectionViewModel.init(model: item)
        })
    }
}
