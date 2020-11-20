//
//  CTSearchViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/7.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON




class CTSearchViewModel: NSObject {
    @objc dynamic open var searchHotDataSource: [String]?
	
	@objc dynamic open var searchRelativeDataSource: [String]?
	
	@objc dynamic open var searchResultDataSource : [CTSearchResltCellViewModel]?
	
	private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)
	
	func searchHot(param : [String:Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.searchHot(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramSearchHotData(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			return Disposables.create()
		}
	}
	
	
	func searchRelative(param: [String:Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			
			if param.count == 0 {
				self.searchRelativeDataSource?.removeAll()
				observable.onNext(nil)
				observable.onCompleted()
			} else {
				self.provider.request(.searchRelative(param: param), callbackQueue: DispatchQueue.main, progress: nil) { (response) in
					switch response {
					case let .success(result):
						self.paramsearchRelativeData(result.data)
						observable.onNext(nil)
						observable.onCompleted()
					case let .failure(error):
						observable.onError(error)
					}
				}
			}
			return Disposables.create()
		}
	}
	
	func searchList(param: [String:Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			
			if param.count == 0 {
				self.searchRelativeDataSource?.removeAll()
				observable.onNext(nil)
				observable.onCompleted()
			} else {
				self.provider.request(.searchResult(param: param), callbackQueue: DispatchQueue.main, progress: nil) { (response) in
					switch response {
					case let .success(result):
						self.paramSearchResultData(result.data)
						observable.onNext(nil)
						observable.onCompleted()
					case let .failure(error):
						observable.onError(error)
					}
				}
			}
			return Disposables.create()
		}
	}
	
	func paramSearchHotData(_ data: Data) -> Void {
		let json = JSON.init(data)
		print(json)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let rankingList: [[String:Any]]? = returnDataDict?["hotItems"] as? [[String:Any]]
		let rankingListModel : [CTSearchHotModel]? = rankingList?.map({ (item) -> CTSearchHotModel in
			return CTSearchHotModel.init(dict: item)
		})
		
		self.searchHotDataSource = rankingListModel?.map({ (model) -> String in
			return model.name ?? ""
		})
	}
	
	func paramsearchRelativeData(_ data: Data) -> Void {
		let json = JSON.init(data)
		print(json)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let rankingList: [[String:Any]]? = dataDict?["returnData"] as? [[String:Any]]
		let rankingListModel : [CTSearchHotModel]? = rankingList?.map({ (item) -> CTSearchHotModel in
			return CTSearchHotModel.init(dict: item)
		})
		
		self.searchRelativeDataSource = rankingListModel?.map({ (model) -> String in
			return model.name ?? ""
		})
	}
	
	func paramSearchResultData(_ data: Data) -> Void {
		let json = JSON.init(data)
		print(json)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let comics: [[String:Any]]? = returnDataDict?["comics"] as? [[String:Any]]
		let rankingListModel : [CTSearchResultModel]? = comics?.map({ (item) -> CTSearchResultModel in
			return CTSearchResultModel.init(item)
		})
		
		self.searchResultDataSource = rankingListModel?.map({ (model) -> CTSearchResltCellViewModel in
			return CTSearchResltCellViewModel.init(model: model)
		})
	}
}


class CTSearchResltCellViewModel : NSObject {
	@objc dynamic var name : String?
	@objc dynamic var tags : String?
	@objc dynamic var author : String?
	@objc dynamic var descriptionValue : String?
	@objc dynamic var comicId : Int = 0
	@objc dynamic var clickTotal: String?
	@objc dynamic var cover: String?
	
	@objc dynamic var model : CTSearchResultModel?
	fileprivate var bag : DisposeBag = DisposeBag.init()
	
	init(model : CTSearchResultModel) {
		super.init()
		self.model = model
		self.createSignals()
	}
	
	func createSignals() -> Void {
		//self.rx.
		self.rx.observeWeakly(String.self, "model.name").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.name = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.author").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.author = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(Array<String>.self, "model.tags").distinctUntilChanged().map({ (value) -> String in
			if (value == nil) || value?.count == 0 {
				return ""
			}
		
			return value?.joined(separator: " ") ?? ""
		}).subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.tags = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.descriptionValue").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.descriptionValue = value
		}).disposed(by: bag)
		
		self.rx.observe(Int.self, "model.comicId").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.comicId = value ?? 0
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.clickTotal").distinctUntilChanged().map {(value) -> String in
			guard let valueItem = value else {
				return ""
			}
			return "总点击 " + valueItem
		}.subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.clickTotal = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.cover").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.cover = value
		}).disposed(by: bag)
	}
}
