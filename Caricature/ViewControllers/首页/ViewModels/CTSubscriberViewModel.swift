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
    var name: String?
    var cover: String?
    var comicId: Int = 0
    var tags: String?
    
    @objc dynamic fileprivate var model: CTSubscriberItemModel?
    
    init(model: CTSubscriberItemModel) {
        self.model = model
        super.init()
        self.bindSignals();
    }
    
    func bindSignals() -> Void {
        
    }
}

class CTSubsciberSectionViewModel: NSObject {
    var maxSize: Int = 0
    var descriptionValue: String?
    var newTitleIconUrl: String?
    var titleIconUrl: String?
    var comics: [CTSubsciberCellViewModel]?
    var itemTitle: String?
    var argValue: Int = 0
    var canMore: Int = 0
    var argName: String?
    
    @objc dynamic fileprivate var model: CTSubscriberModel?
    
    init(model: CTSubscriberModel) {
        self.model = model;
        super.init()
        self.bindSignals();
    }
    
    func bindSignals() -> Void {
        
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
