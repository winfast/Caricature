//
//  CTComicDetailModel.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/11.
//

import UIKit

class CTClassifyTagsModel: NSObject {
	@objc dynamic var name : String?
	@objc dynamic var argVal : Int = 0
	@objc dynamic var argName : String?
	
	init(dict : [String:Any]?) {
		super.init()
		self.name = dict?["name"] as? String ?? nil
		self.argVal = dict?["argVal"] as? Int ?? 0
		self.argName = dict?["argName"] as? String ?? nil
	}
}

class CTAuthorModel: NSObject {
	@objc dynamic var avatar : String?
	@objc dynamic var name : String?
	@objc dynamic var id : String?
	
	init(dict : [String:Any]?) {
		super.init()
		self.avatar = dict?["avatar"] as? String ?? nil
		self.name = dict?["name"] as? String ?? nil
		self.id = dict?["id"] as? String ?? nil
	}
}

class CTComicDetailModel: NSObject {
	@objc dynamic var thread_id : String?
	@objc dynamic var classifyTags : [CTClassifyTagsModel]?
	@objc dynamic var theme_ids : [String]?
	@objc dynamic var is_vip : Int = 0
	@objc dynamic var level : String?
	@objc dynamic var author : CTAuthorModel?
	@objc dynamic var accredit : Int = 0
	@objc dynamic var is_dub : Int = 0
	@objc dynamic var short_description : String?
	@objc dynamic var last_update_time : Int = 0
	@objc dynamic var type : String?
	@objc dynamic var is_week : Int = 0
	@objc dynamic var comic_id : String?
	@objc dynamic var name : String?
	@objc dynamic var ori : String?
	@objc dynamic var wideCover : String?
	@objc dynamic var series_status : String?
	@objc dynamic var cate_id : String?
	@objc dynamic var last_update_week : String?
	@objc dynamic var descriptionValue : String?
	@objc dynamic var status : Int = 0
	@objc dynamic var cover : String?
	
	init(dict : [String:Any]?) {
		super.init()
		self.name = dict?["name"] as? String ?? nil
		self.thread_id = dict?["thread_id"] as? String ?? nil
		
		let array : [[String:Any]]? = dict?["classifyTags"] as? [[String:Any]] ?? nil
		self.classifyTags = array?.map({ (dict) -> CTClassifyTagsModel in
			return CTClassifyTagsModel.init(dict: dict)
		})
		
		self.theme_ids = dict?["name"] as? [String] ?? nil
		self.is_vip = dict?["is_vip"] as? Int ?? 0
		self.level = dict?["level"] as? String ?? nil
		self.author = CTAuthorModel.init(dict: dict?["author"] as? [String:Any] ?? nil)
		self.accredit = dict?["accredit"] as? Int ?? 0
		self.is_dub = dict?["is_dub"] as? Int ?? 0
		self.short_description = dict?["short_description"] as? String ?? nil
		self.last_update_time = dict?["last_update_time"] as? Int ?? 0
		self.type = dict?["type"] as? String ?? nil
		self.is_week = dict?["is_week"] as? Int ?? 0
		self.comic_id = dict?["comic_id"] as? String ?? nil
		self.ori = dict?["ori"] as? String ?? nil
		self.wideCover = dict?["wideCover"] as? String ?? nil
		self.series_status = dict?["series_status"] as? String ?? nil
		self.cate_id = dict?["cate_id"] as? String ?? nil
		self.last_update_week = dict?["last_update_week"] as? String ?? nil
		self.status = dict?["status"] as? Int ?? 0
		self.descriptionValue = dict?["description"] as? String ?? nil
		self.cover = dict?["cover"] as? String ?? nil
	}
}

class CTComicOtherWorksItemModel : NSObject {
	@objc dynamic var coverUrl : String?
	@objc dynamic var name : String?
	@objc dynamic var comicId : String?
	@objc dynamic var passChapterNum : String?
	
	init(dict : [String:Any]?) {
		super.init()
		self.coverUrl = dict?["coverUrl"] as? String ?? nil
		self.name = dict?["name"] as? String ?? nil
		self.comicId = dict?["comicId"] as? String ?? nil
		self.passChapterNum = dict?["passChapterNum"] as? String ?? nil
	}
}

class CTChapterItemModel : NSObject {
    @objc dynamic var type : Int = 0
	@objc dynamic var imHightArr : [[[String : Any]]]?  //数组(数组(字典))
	@objc dynamic var zip_high_webp : String?
	@objc dynamic var price : String?
	@objc dynamic var name : String?
	@objc dynamic var is_new : Int = 0
	@objc dynamic var size : String?
	@objc dynamic var crop_zip_size : String?
	@objc dynamic var image_total: String?
	@objc dynamic var countImHightArr : Int = 0
	@objc dynamic var chapter_id : String?
	@objc dynamic var has_locked_image : Bool = false
	@objc dynamic var pass_time : Int = 0
	
	init(dict : [String:Any]?) {
		super.init()
		self.type = dict?["type"] as? Int ?? 0
		self.zip_high_webp = dict?["zip_high_webp"] as? String ?? nil
		self.price = dict?["price"] as? String ?? nil
		self.price = dict?["price"] as? String ?? nil
		self.name = dict?["name"] as? String ?? nil
		self.size = dict?["size"] as? String ?? nil
		self.crop_zip_size = dict?["crop_zip_size"] as? String ?? nil
		self.image_total = dict?["image_total"] as? String ?? nil
		self.chapter_id = dict?["chapter_id"] as? String ?? nil
		self.countImHightArr = dict?["countImHightArr"] as? Int ?? 0
		self.has_locked_image = dict?["has_locked_image"] as? Bool ?? false
		self.pass_time = dict?["pass_time"] as? Int ?? 0
		self.imHightArr = dict?["imHightArr"] as? [[[String : Any]]] ?? nil
	}
}


class CTComicDetailRealtimeModel: NSObject {
	@objc dynamic var click_total: String?
	@objc dynamic var comic_id: String?
	@objc dynamic var is_vip_buy: Bool = false
	@objc dynamic var monthly_ticket: Int = 0
	@objc dynamic var user_id: String?
	@objc dynamic var gift_total: String?
	@objc dynamic var is_buy_action: Int = 0
	@objc dynamic var total_ticket: Int = 0
	@objc dynamic var status: String?
	@objc dynamic var comment_total: String?
	@objc dynamic var is_vip_free: Bool = false
	@objc dynamic var total_tucao: Int = 0
	@objc dynamic var is_auto_buy: Int = 0
	@objc dynamic var favorite_total: String?
	@objc dynamic var is_free: Int = 0
	@objc dynamic var vip_discount: Float = 0.0
	
	init(dict: [String:Any]?) {
		super.init()
		self.click_total = dict?["click_total"] as? String ?? nil
		self.comic_id = dict?["comic_id"] as? String ?? nil
		self.is_vip_buy = dict?["is_vip_buy"] as? Bool ?? false
		self.monthly_ticket = dict?["monthly_ticket"] as? Int ?? 0
		self.user_id = dict?["user_id"] as? String ?? nil
		self.gift_total = dict?["gift_total"] as? String ?? nil
		self.is_buy_action = dict?["is_buy_action"] as? Int ?? 0
		self.total_ticket = dict?["total_ticket"] as? Int ?? 0
		self.status = dict?["status"] as? String ?? nil
		self.comment_total = dict?["comment_total"] as? String ?? nil
		self.is_vip_free = dict?["is_vip_free"] as? Bool ?? false
		self.total_tucao = dict?["total_tucao"] as? Int ?? 0
		self.is_auto_buy = dict?["is_auto_buy"] as? Int ?? 0
		self.favorite_total = dict?["favorite_total"] as? String ?? nil
		self.is_free = dict?["is_free"] as? Int ?? 0
		self.vip_discount = dict?["vip_discount"] as? Float ?? 0.0
	}
}


class CTComicCommnetModel: NSObject {
    @objc dynamic var face: String?
    @objc dynamic var content_filter: String?
    @objc dynamic var nickname: String?
    
    init(dict: [String:Any]?) {
        super.init()
        self.face = dict?["face"] as? String ?? nil
        self.content_filter = dict?["content_filter"] as? String ?? nil
        self.nickname = dict?["nickname"] as? String ?? nil
    }
}

class CTComicGuessLikeModel: NSObject {
    @objc dynamic var cover: String?
    var new_comic: Bool = false
    @objc dynamic var ori_cover: String?
    @objc dynamic var name: String?
    @objc dynamic var comic_id: String?
    var short_description: String?
    
    init(dict: [String:Any]?) {
        super.init()
        self.cover = dict?["cover"] as? String ?? nil
        self.new_comic = dict?["new_comic"] as? Bool ?? false
        self.ori_cover = dict?["ori_cover"] as? String ?? nil
        self.name = dict?["name"] as? String ?? nil
        self.comic_id = dict?["comic_id"] as? String ?? nil
        self.short_description = dict?["short_description"] as? String ?? nil
    }
}
