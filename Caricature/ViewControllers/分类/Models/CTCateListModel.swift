//
//  CTCateListModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/6.
//

import UIKit

class CTCateListModel: NSObject {
	@objc dynamic open var argName : String?
	@objc dynamic open var sortId : Int = 0
	@objc dynamic open var argValue : Int = 0
	@objc dynamic open var argCon : Int = 0
	@objc dynamic open var isLike : Bool = false
	@objc dynamic open var sortName : String?
	@objc dynamic open var canEdit : Bool = false
	@objc dynamic open var cover : String?
	
	init(_ dict: [String:Any]) {
		self.argName = dict["argName"] as? String ?? nil
		self.sortId = dict["sortId"] as? Int ?? 0
		self.argValue = dict["argValue"] as? Int ?? 0
		self.argCon = dict["argCon"] as? Int ?? 0
		self.isLike = dict["isLike"] as? Bool ?? false
		self.sortName = dict["sortName"] as? String ?? nil
		self.canEdit = dict["canEdit"] as? Bool ?? false
		self.cover = dict["cover"] as? String ?? nil
	}
}
