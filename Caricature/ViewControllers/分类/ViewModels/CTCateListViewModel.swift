//
//  CTCateListViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/6.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON


class CTCateListCellViewModel: NSObject {
	@objc dynamic open var argName : String?
	@objc dynamic open var sortId : Int = 0
	@objc dynamic open var argValue : Int = 0
	@objc dynamic open var argCon : Int = 0
	@objc dynamic open var sortName : String?
	@objc dynamic open var cover : String?
	
	@objc dynamic open var model: CTCateListModel?
	fileprivate var bag : DisposeBag = DisposeBag.init()
	
	init(_ model: CTCateListModel) {
		super.init()
		self.model = model
		self.createSignals()
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "model.cover").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.cover = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.sortName").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.sortName = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.argName").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.argName = value
		}).disposed(by: bag)
		
		self.rx.observe(Int.self, "model.sortId").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.sortId = value ?? 0
		}).disposed(by: bag)
		
		self.rx.observe(Int.self, "model.argValue").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.argValue = value ?? 0
		}).disposed(by: bag)
		
		self.rx.observe(Int.self, "model.argCon").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.argCon = value ?? 0
		}).disposed(by: bag)
	}
}

class CTCateListViewModel: NSObject {
	open var dataSource: [CTCateListCellViewModel]?
	
	private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)
	
	func cateList(param : [String:Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.cateList(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramCateListData(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			return Disposables.create()
		}
	}
	
	func paramCateListData(_ data: Data) -> Void {
		let json = JSON.init(data)
		print(json)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let rankingList: [[String:Any]]? = returnDataDict?["rankingList"] as? [[String:Any]]
		let rankingListModel : [CTCateListModel]? = rankingList?.map({ (item) -> CTCateListModel in
			return CTCateListModel.init(item)
		})
		
		self.dataSource = rankingListModel?.map({ (model) -> CTCateListCellViewModel in
			return CTCateListCellViewModel.init(model)
		})
	}
}
