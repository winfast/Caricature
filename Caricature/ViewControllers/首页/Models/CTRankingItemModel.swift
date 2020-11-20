//
//  CTRankingItemModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit

class CTRankingItemModel: NSObject {
	
	@objc dynamic open var subTitle: String?
	@objc dynamic open var argValue: String?
	@objc dynamic open var title: String?
	@objc dynamic open var cover: String?
	
	open var rankingType: String?
	open var is_vip: Int?
	open var argName : String?
	
	init(dict: [String:Any]) {
		self.subTitle = dict["subTitle"] as? String ?? nil
		self.cover = dict["cover"] as? String ?? nil
		self.argName = dict["argName"] as? String ?? nil
		self.is_vip = dict["is_vip"] as? Int ?? nil
		self.cover = dict["cover"] as? String ?? nil
		self.title = dict["title"] as? String ?? nil
		self.rankingType = dict["rankingType"] as? String ?? nil
	}
}
