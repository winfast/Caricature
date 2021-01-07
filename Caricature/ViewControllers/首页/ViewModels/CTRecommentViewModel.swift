//
//  CTRecommednViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/3.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class CTRecommentViewModel: NSObject {
	
	@objc dynamic open var dataSource: [CTRecommentSectionViewModel]?

	//static let share = CTHomeNetworkManager.init()
	private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)
	
	func searchHot(param: [String : String]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.searchHot(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramSearchHot(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			
			return Disposables.create()
		}
	}
	
	func boutiqueList(param: [String : Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.boutiqueListPath(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramBoutiqueList(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			
			return Disposables.create()
		}
	}
	
	func paramSearchHot(_ data: Any) -> Void {
		let json = JSON.init(data)
		let dicts: [String: Any]? = json.dictionaryObject
	}
	
	func paramBoutiqueList(_ data: Any) -> Void {
		let json = JSON.init(data)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let comicLists : [Any]? = returnDataDict?["comicLists"] as? [Any]
        
        let comicListsModel : [CTComicListModel]? = comicLists?.filter({ (item) -> Bool in
            let temp : [String:Any]? = item as? [String :Any];
            guard let _ = temp else {
                return false
            }
            return true
        }).map({ (item) -> CTComicListModel in
            return CTComicListModel.init(dict: item as! [String : Any])
        })
        
//		let comicListsModel : [CTComicListModel]? = (comicLists?.map({ (item) -> CTComicListModel in
//
//			return CTComicListModel.init(dict: item as! [String : Any])
//		}))
		
		self.dataSource = comicListsModel?.map({ (item) -> CTRecommentSectionViewModel in
			return CTRecommentSectionViewModel.init(mode: item)
		})
	}
}
