//
//  CTSubscriberModel.swift
//  Caricature
//
//  Created by Qincc on 2021/3/3.
//

import UIKit

class CTSubscriberItemModel: NSObject {
    @objc dynamic var name: String?
    @objc dynamic var cover: String?
    @objc dynamic var comicId: Int = 0
    var tags: String?
    
    init(_ dict: [String:Any]) {
        self.name = dict["name"] as? String ?? nil
        self.cover = dict["cover"] as? String ?? nil
        self.comicId = dict["comicId"] as? Int ?? 0
        self.tags = dict["tags"] as? String ?? nil
    }
}

class CTSubscriberModel: NSObject {
    var maxSize: Int = 0
    var descriptionValue: String?
    var newTitleIconUrl: String?
    @objc dynamic var titleIconUrl: String?
    @objc dynamic var comics: [CTSubscriberItemModel]?
    @objc dynamic var itemTitle: String = ""
    @objc dynamic var  argValue: String?
    var canMore: Int = 0
    @objc dynamic var argName: String?

    init(_ dict: [String:Any]) {
        self.maxSize = dict["maxSize"] as? Int ?? 0
        self.itemTitle = dict["itemTitle"] as? String ?? ""
        self.titleIconUrl = dict["titleIconUrl"] as? String ?? nil
        self.argValue = dict["argValue"] as? String ?? nil
        self.argName = dict["argName"] as? String ?? nil
        self.descriptionValue = dict["description"] as? String ?? nil
        let comicsArray: [[String: Any]] = dict["comics"] as? [[String:Any]] ?? []
        
        self.comics = comicsArray.map({ (item) -> CTSubscriberItemModel in
            return CTSubscriberItemModel.init(item)
        });
    }
}


