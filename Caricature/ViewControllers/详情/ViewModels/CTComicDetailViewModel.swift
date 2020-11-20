//
//  CTComicDetailViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/11.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class CTChapterCellViewModel: NSObject {
	@objc dynamic var name :String?
	
	@objc dynamic fileprivate var model : CTChapterItemModel?
	
	private var bag : DisposeBag = DisposeBag.init()
	
	init(currModel : CTChapterItemModel) {
		super.init()
		self.model = currModel
		
		self.createSignals()
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "model.name").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.name = value;
		}).disposed(by: bag)
	}
}

class CTOtherWorkCellViewModel: NSObject {
	
	@objc dynamic var coverUrl : String?
	@objc dynamic var name : String?
	@objc dynamic var comicId : String?
	@objc dynamic var passChapterNum : String?
	
	@objc dynamic fileprivate var model : CTComicOtherWorksItemModel?
	
	private var bag : DisposeBag = DisposeBag.init()
	
	init(currModel: CTComicOtherWorksItemModel) {
		super.init()
		self.model = currModel
		self.createSignals()
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "model.coverUrl").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.coverUrl = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.name").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.name = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.comicId").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.comicId = value
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "model.passChapterNum").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.passChapterNum = value
		}).disposed(by: bag)
	}
	
}

class CTComicDetaiInfoViewModel: NSObject {
	@objc dynamic var name : String?
	@objc dynamic var authorName : String?
	@objc dynamic var workDescription : String?
	@objc dynamic var wideCover : String?
	@objc dynamic var cover : String?
	
	@objc dynamic var monthly_ticket : Int = 0 //本月月票
	@objc dynamic var click_total: String? //总点击数
	@objc dynamic var total_ticket: Int = 0 //累计月票
	@objc dynamic var favorite_total: String? //收藏
	@objc dynamic var classifyTags : [String]? //漫画类型
	@objc dynamic var lastUpdateTime : String?
}

class CTComicDetailViewModel: NSObject {
	@objc dynamic open var dataSource: [CTRecommentSectionViewModel]?

	//static let share = CTHomeNetworkManager.init()
	private let provider = MoyaProvider<CTNetworkMoya>.init(requestClosure: timeoutClosure)

	var comicDetaiInfoViewModel : CTComicDetaiInfoViewModel = CTComicDetaiInfoViewModel.init()
	
	@objc dynamic var comicOtherWorkingDataSource: Array<CTOtherWorkCellViewModel>?
	
	@objc dynamic var comicChapterDataSource : Array<CTChapterCellViewModel>?

//
//	var commentViewModel:
	
	func comicDetail(param: [String : Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.detailStatic(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramComicDetailData(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			
			return Disposables.create()
		}
	}
	
	func comicDetailRealtime(param: [String : Any]) -> Observable<Void?> {
		return Observable<Void?>.create { (observable) -> Disposable in
			self.provider.request(.detailRealtime(param: param), callbackQueue: DispatchQueue.main, progress: nil) { [weak self] (response) in
				switch response {
				case let .success(result):
					self?.paramComicDetailRealtimeData(result.data)
					observable.onNext(nil)
					observable.onCompleted()
				case let .failure(error):
					observable.onError(error)
				}
			}
			
			return Disposables.create()
		}
	}
	
	func paramComicDetailData(_ data : Data) -> Void {
		let json = JSON.init(data)
		print(json)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let comicDetail : [String:Any]? = returnDataDict?["comic"] as? [String:Any]
		let comicDeatailModel = CTComicDetailModel.init(dict: comicDetail)
		
		self.comicDetaiInfoViewModel.name = comicDeatailModel.name
		self.comicDetaiInfoViewModel.authorName = comicDeatailModel.author?.name
		self.comicDetaiInfoViewModel.workDescription = "【" + comicDeatailModel.cate_id! +  "】" + comicDeatailModel.descriptionValue!
		self.comicDetaiInfoViewModel.wideCover = comicDeatailModel.wideCover
		self.comicDetaiInfoViewModel.cover = comicDeatailModel.cover
		self.comicDetaiInfoViewModel.lastUpdateTime = String.showTimeFrom(timeStamp: comicDeatailModel.last_update_time, formatTime: "yyyy-MM-dd")
		self.comicDetaiInfoViewModel.classifyTags = comicDeatailModel.classifyTags?.map({ (model) -> String in
			return model.name!
		})
		
		
		let array : [[String:Any]]? = returnDataDict?["otherWorks"] as? [[String:Any]]
		let temp : [CTComicOtherWorksItemModel]? = array?.map({ (dict) -> CTComicOtherWorksItemModel in
			return CTComicOtherWorksItemModel.init(dict: dict)
		})
		
		self.comicOtherWorkingDataSource = temp?.map({ (model) -> CTOtherWorkCellViewModel in
			return CTOtherWorkCellViewModel.init(currModel: model)
		})
		
		let chapterList : [[String:Any]]? = returnDataDict?["chapter_list"] as? [[String:Any]]
		let chapterListArray : [CTChapterItemModel]? = chapterList?.map { (dict) -> CTChapterItemModel in
			return CTChapterItemModel.init(dict: dict)
		}
		
		self.comicChapterDataSource = chapterListArray?.map({ (model) -> CTChapterCellViewModel in
			return CTChapterCellViewModel.init(currModel: model)
		})
		
//		let comicListsModel : [CTComicListModel]? = (comicLists?.map({ (item) -> CTComicListModel in
//			return CTComicListModel.init(dict: item as! [String : Any])
//		}))
	}
	
	
	func paramComicDetailRealtimeData(_ data : Data) -> Void {
		let json = JSON.init(data)
		print(json)
		let dicts: [String: Any]? = json.dictionaryObject
		let dataDict : [String : Any]? = dicts?["data"] as? [String: Any];
		let stateCode : Int? = dataDict?["stateCode"] as? Int
		if stateCode == nil || stateCode != 1 {
			return
		}
		
		/*
		@objc dynamic var monthly_ticket : Int = 0 //本月月票
		@objc dynamic var click_total: String? //总点击数
		@objc dynamic var total_ticket: Int = 0 //累计月票
		@objc dynamic var favorite_total: Int = 0 //收藏
		*/
		
		let returnDataDict: [String:Any]? = dataDict?["returnData"] as? [String:Any]
		let comicDetail : [String:Any]? = returnDataDict?["comic"] as? [String:Any]
		let comicDetailRealtimeModel = CTComicDetailRealtimeModel.init(dict: comicDetail)
		self.comicDetaiInfoViewModel.monthly_ticket = comicDetailRealtimeModel.monthly_ticket
		self.comicDetaiInfoViewModel.click_total = comicDetailRealtimeModel.click_total
		self.comicDetaiInfoViewModel.total_ticket = comicDetailRealtimeModel.total_ticket
		self.comicDetaiInfoViewModel.favorite_total = comicDetailRealtimeModel.favorite_total
		
	}
}
