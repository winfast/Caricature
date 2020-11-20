//
//  CTRecommentCellViewModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/3.
//

import UIKit
import RxSwift

class CTRecommentSectionViewModel: NSObject {
	
	/// section 标题
	@objc dynamic open var itemTitle : String?
	
	/// section图标
	@objc dynamic open var newTitleIconUrl : String?
	
	/// section的item
	@objc dynamic open var comics : [CTRecommentCellViewModel]?
	
	@objc dynamic fileprivate var mode : CTComicListModel?
	
	let disposeBag : DisposeBag = DisposeBag.init()
	
	init(mode : CTComicListModel) {
		super.init()
		self.mode = mode
		self.createSignals()
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "mode.itemTitle").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.itemTitle = value
		}).disposed(by: disposeBag)
		
		self.rx.observeWeakly(String.self, "mode.newTitleIconUrl").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.newTitleIconUrl = value
		}).disposed(by: disposeBag)
		
		self.rx.observe(Array<CTRecommentItemModel>.self, "mode.comics").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			//数组转换成cellViewModel
			weakself.comics = value?.map({ (item : CTRecommentItemModel) -> CTRecommentCellViewModel in
				return CTRecommentCellViewModel.init(mode: item)
			})
			
		}).disposed(by: disposeBag)
	}
}


class CTRecommentCellViewModel: NSObject {
	@objc dynamic open var name : String?
	@objc dynamic open var subTitle : String?
	@objc dynamic open var cover: String?
	@objc dynamic open var comicId: Int = 0
	
	@objc dynamic fileprivate var mode: CTRecommentItemModel?
	
	let disposeBag : DisposeBag = DisposeBag.init()
	
	init(mode :CTRecommentItemModel) {
		super.init()
		self.mode = mode
		self.createSignals()
	}
	
	func createSignals() -> Void {
		//使用 observeWeakly 防止内存未释放
		self.rx.observeWeakly(String.self, "mode.name").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.name = value
		}).disposed(by: disposeBag)
		
		self.rx.observeWeakly(String.self, "mode.subTitle").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.subTitle = value
		}).disposed(by: disposeBag)
		
		self.rx.observeWeakly(String.self, "mode.cover").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.cover = value
		}).disposed(by: disposeBag)
		
		self.rx.observe(Int.self, "mode.comicId").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.comicId = value ?? 0
		}).disposed(by: disposeBag)
	}
}
