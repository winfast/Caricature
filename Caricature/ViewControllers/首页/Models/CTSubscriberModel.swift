//
//  CTSubscriberModel.swift
//  Caricature
//
//  Created by Qincc on 2021/3/3.
//

import UIKit

class CTSubscriberItemModel: NSObject {
    var name: String?
    var cover: String?
    var comicId: Int = 0
    var tags: String?
    
    init(_ dict: [String:Any]) {
        self.name = dict["name"] as? String ?? nil
        self.cover = dict["cover"] as? String ?? nil
        self.comicId = dict["newTitleIconUrl"] as? Int ?? 0
        self.tags = dict["tags"] as? String ?? nil
    }
}

class CTSubscriberModel: NSObject {
    var maxSize: Int = 0
    var descriptionValue: String?
    var newTitleIconUrl: String?
    var titleIconUrl: String?
    var comics: [CTSubscriberItemModel]?
    var itemTitle: String?
    var argValue: Int = 0
    var canMore: Int = 0
    var argName: String?

    init(_ dict: [String:Any]) {
        self.maxSize = dict["maxSize"] as? Int ?? 0
        self.itemTitle = dict["maxSize"] as? String ?? nil
        self.newTitleIconUrl = dict["newTitleIconUrl"] as? String ?? nil
        let comicsArray: [[String: Any]] = dict["comics"] as? [[String:Any]] ?? []
        
        self.comics = comicsArray.map({ (item) -> CTSubscriberItemModel in
            return CTSubscriberItemModel.init(item)
        });
    }
}


