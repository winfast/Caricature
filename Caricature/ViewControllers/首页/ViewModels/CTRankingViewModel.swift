//
//  CTRankingViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class CTRankingViewModel: NSObject {
	@objc dynamic open var dataSource: [CTRankingCellViewModel]?

	//static let share = CTHomeNetworkManager.init()
	private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)
	
	func rankList(param: [String : String]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.rankList(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramRankList(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			
			return Disposables.create()
		}
	}
	
	func paramRankList(_ data: Any) -> Void {
		let json = JSON.init(data)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let rankingLists : [Any]? = returnDataDict?["rankinglist"] as? [Any]
		let rankingListsModel : [CTRankingItemModel]? = (rankingLists?.map({ (item) -> CTRankingItemModel in
			return CTRankingItemModel.init(dict: item as! [String : Any])
		}))
		
		self.dataSource = rankingListsModel?.map({ (item) -> CTRankingCellViewModel in
			return CTRankingCellViewModel.init(model: item)
		})
	}
}

class CTRankingCellViewModel: NSObject {
	@objc dynamic open var subTitle: String?
	@objc dynamic open var argValue: String?
	@objc dynamic open var title: String?
	@objc dynamic open var cover: String?
	
	@objc dynamic fileprivate var model: CTRankingItemModel?
	//open var is_vip: Int?
	//open var argName : String?
	
	fileprivate let bag : DisposeBag = DisposeBag.init()
	
	init(model: CTRankingItemModel) {
		super.init()
		self.model = model
		self.createSignals()
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "model.subTitle").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.subTitle = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.argValue").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.argValue = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.title").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.title = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.cover").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.cover = value
		}).disposed(by: bag)
	}
}
