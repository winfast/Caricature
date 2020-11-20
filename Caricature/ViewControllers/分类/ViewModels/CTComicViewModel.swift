//
//  CTComicViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/10.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class CTComicListViewModel : NSObject {
	open var dataSource: [CTSearchResltCellViewModel]?
	@objc dynamic var hasMore : Bool = true
	@objc dynamic var spinnerName : String?
	var page: Int = 1
	
	private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)
	
	func comicList(param : [String:Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.comicList(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramComicListData(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			return Disposables.create()
		}
	}
	
	func paramComicListData(_ data: Data) -> Void {
		let json = JSON.init(data)
		print(json)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		
		self.hasMore = returnDataDict?["hasMore"] as? Bool ?? true
		self.page = returnDataDict?["page"] as? Int ?? 1
		
		let defaultParametersDict : [String:Any]? = returnDataDict?["defaultParameters"] as? [String:Any] ?? [:]
		self.spinnerName = defaultParametersDict?["defaultConTagType"] as? String ?? ""
		
		let comicsList: [[String:Any]]? = returnDataDict?["comics"] as? [[String:Any]]
		let rankingListModel : [CTSearchResultModel]? = comicsList?.map({ (item) -> CTSearchResultModel in
			return CTSearchResultModel.init(item)
		})
		
		if self.page == 1 {
			self.dataSource = rankingListModel?.map({ (model) -> CTSearchResltCellViewModel in
				return CTSearchResltCellViewModel.init(model: model)
			})
		} else {
			self.dataSource = self.dataSource! + (rankingListModel?.map({ (model) -> CTSearchResltCellViewModel in
				return CTSearchResltCellViewModel.init(model: model)
			}))!
		}
		
	
	}
}

