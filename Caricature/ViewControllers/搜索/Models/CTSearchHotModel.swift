//
//  CTSearchHotModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/7.
//

import UIKit

class CTSearchHotModel: NSObject {
	
	@objc dynamic var bgColor : String?
	@objc dynamic var name : String?
	@objc dynamic var comic_id : String?
	
	init(dict : [String:Any]) {
		self.bgColor = dict["bgColor"] as? String ?? ""
		self.name = dict["name"] as? String ?? ""
		self.comic_id = dict["comic_id"] as? String ?? ""
	}
}


class CTSearchResultModel: NSObject {
	@objc dynamic var conTag: Int = 0
	@objc dynamic var author : String?
	@objc dynamic var descriptionValue : String?
	@objc dynamic var monthTicket : String?
	@objc dynamic var tags : Array<String>?
	@objc dynamic var comicId : Int = 0
	@objc dynamic var name : String?
	@objc dynamic var clickTotal : String?
	@objc dynamic var passChapterNum : String?
	@objc dynamic var flag : String?
	@objc dynamic var cover : String?
	@objc dynamic var seriesStatus : String?
	
	init(_ dict : [String:Any]) {
		self.conTag = dict["conTag"] as? Int ?? 0
		self.author = dict["author"] as? String ?? nil
		self.descriptionValue = dict["description"] as? String ?? nil
		self.monthTicket = dict["monthTicket"] as? String ?? nil
		self.tags = dict["tags"] as? Array<String> ?? nil
		self.comicId = dict["comicId"] as? Int ?? 0
		self.name = dict["name"] as? String ?? nil
		self.clickTotal = dict["clickTotal"] as? String ?? nil
		self.passChapterNum = dict["passChapterNum"] as? String ?? nil
		self.flag = dict["flag"] as? String ?? nil
		self.cover = dict["cover"] as? String ?? nil
		self.seriesStatus = dict["seriesStatus"] as? String ?? nil
	}
}
