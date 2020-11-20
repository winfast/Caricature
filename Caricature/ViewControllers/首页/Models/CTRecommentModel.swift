//
//  CTRecommentModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/3.
//

import UIKit

class CTRecommentItemModel: NSObject {
	
	open var short_description: String?
	@objc dynamic open var subTitle: String?
	@objc dynamic open var comicId: Int = 0
	open var tags: [String]?
	open var cornerInfo: String?
	@objc dynamic open var cover: String?
	@objc dynamic open var name: String?
	open var is_vip: Int?
	open var author_name : String?
	open var descriptionValue: String?
	
	init(dict: [String:Any]) {
		self.short_description = dict["short_description"] as? String ?? nil
		self.subTitle = dict["subTitle"] as? String ?? nil
		self.comicId = dict["comicId"] as? Int ?? 0
		self.tags = dict["tags"] as? [String] ?? nil
		self.cornerInfo = dict["cornerInfo"] as? String ?? nil
		self.cover = dict["cover"] as? String ?? nil
		self.name = dict["name"] as? String ?? nil
		self.is_vip = dict["is_vip"] as? Int ?? nil
		self.author_name = dict["author_name"] as? String ?? nil
		self.descriptionValue = dict["description"] as? String ?? nil
	}
}

class CTComicListModel: NSObject {
	@objc dynamic open var itemTitle: String?
	open var argName: String?
	open var descriptionValue: String?
	open var argValue : Int?
	open var canedit : Int?
	@objc dynamic open var newTitleIconUrl : String?
	@objc dynamic open var titleIconUrl: String?
	open var sortId : String?
	open var comicType : Int?
	@objc dynamic open var comics : [CTRecommentItemModel]?
	
	init(dict: [String:Any]) {
		self.itemTitle = dict["itemTitle"] as? String ?? nil
		self.argName = dict["argName"] as? String ?? nil
		self.descriptionValue = dict["description"] as? String ?? nil
		self.argValue = dict["argValue"] as? Int ?? nil
		self.newTitleIconUrl = dict["newTitleIconUrl"] as? String ?? nil
		self.titleIconUrl = dict["titleIconUrl"] as? String ?? nil
		self.sortId = dict["sortId"] as? String ?? nil
		self.comicType = dict["comicType"] as? Int ?? nil
		let array = dict["comics"] as? Array<[String: Any]>
		self.comics = array?.map({ (item) -> CTRecommentItemModel in
			return CTRecommentItemModel.init(dict: item)
		})
	}
}


