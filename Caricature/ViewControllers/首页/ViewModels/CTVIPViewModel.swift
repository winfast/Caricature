//
//  CTVIPViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class CTVIPViewModel: NSObject {
	@objc dynamic open var dataSource: [CTRecommentSectionViewModel]?

	//static let share = CTHomeNetworkManager.init()
	private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)
	
	func searchHot(param: [String : String]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.vipList(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramVIP(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			return Disposables.create()
		}
	}

	func paramVIP(_ data: Any) -> Void {
		let json = JSON.init(data)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let comicLists : [Any]? = returnDataDict?["comicLists"] as? [Any]
		let comicListsModel : [CTComicListModel]? = (comicLists?.map({ (item) -> CTComicListModel in
			return CTComicListModel.init(dict: item as! [String : Any])
		}))
		
		self.dataSource = comicListsModel?.map({ (item) -> CTRecommentSectionViewModel in
			return CTRecommentSectionViewModel.init(mode: item)
		})
	}
}
