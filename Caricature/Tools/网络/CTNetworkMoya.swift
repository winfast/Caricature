//
//  CTNetworkMoya.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/4.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import Alamofire
import SwiftyJSON

//enum CTNetworkString {
//	case baseURL
////	case Greyjoy = "We Do Not Sow"
////	case Martell = "Unbowed, Unbent, Unbroken"
////	case Stark = "Winter is Coming"
////	case Tully = "Family, Duty, Honor"
////	case Tyrell = "Growing Strong"
//
//
//	static func valueWithType(value: CTNetworkString) -> String {
//		switch value {
//		case .baseURL:
//			return "http://app.u17.com/v3/appV3_3/ios/phone"
//		default:
//			return ""
//		}
//	}
//}

enum CTNetworkString : String {
	case baseURL = "http://app.u17.com/v3/appV3_3/ios/phone"
	case searchHotPath = "search/hotkeywordsnew"
	case searchRelativePath = "search/relative"
	case searchResultPath = "search/searchResult"
    case subscribeListPath = "";
	
	
	case boutiqueListPath = "comic/boutiqueListNew"
	case specialPath = "comic/special"
	case vipListPath = "list/vipList"
	case rankListPath = "rank/list"
	case cateListPath = "sort/mobileCateList"
	case comicListPath = "list/commonComicList"
	case detailStaticPath = "comic/detail_static_new"  //基本详情
	case detailRealtimePath = "comic/detail_realtime"
    case commentListPath = "comment/list"
    case guessLikePath = "list/newSubscribeList"  //订阅列表
}

//有关联值的枚举
enum CTNetworkMoya {
	case searchHot(param: [String : Any])
	case searchRelative(param: [String : Any])
	case searchResult(param: [String : Any])
	case boutiqueListPath(param: [String : Any])
	case vipList(param: [String : Any])
	case rankList(param: [String : Any])
	case cateList(param: [String : Any])
	case comicList(param: [String : Any])
	case detailStatic(param: [String : Any])
	case detailRealtime(param: [String : Any])
    case commentList(param: [String : Any])
    case guessLike
    case subscribeList
}

//添加Header
//let endpointClosure: (CTNetworkMoya) -> Endpoint = { (target) -> Endpoint in
//	let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
//	return defaultEndpoint.adding(newHTTPHeaderFields: ["APP_NAME": "MY_AWESOME_APP"])
//}


//添加超时设置
let timeoutClosure: (Endpoint, @escaping MoyaProvider<CTNetworkMoya>.RequestResultClosure) -> Void = { (endPoint: Endpoint, closure: MoyaProvider<CTNetworkMoya>.RequestResultClosure) -> Void in
	if var urlRequest: URLRequest = try? endPoint.urlRequest() {
		urlRequest.timeoutInterval = 10
		closure(.success(urlRequest))
	} else {
		closure(.failure(MoyaError.requestMapping(endPoint.url)))
	}
}

extension CTNetworkMoya : TargetType {
	var baseURL: URL {
		return URL(string: CTNetworkString.baseURL.rawValue)!
	}
	
	var path: String {
		switch self {
		case .searchHot:
			return CTNetworkString.searchHotPath.rawValue
		case .searchRelative:
			return CTNetworkString.searchRelativePath.rawValue
		case .searchResult:
			return CTNetworkString.searchResultPath.rawValue
		case .boutiqueListPath:
			return CTNetworkString.boutiqueListPath.rawValue
		case .vipList:
			return CTNetworkString.vipListPath.rawValue
		case .rankList:
			return CTNetworkString.rankListPath.rawValue
		case .cateList:
			return CTNetworkString.cateListPath.rawValue
        case .comicList:
            return CTNetworkString.comicListPath.rawValue
        case .detailStatic:
            return CTNetworkString.detailStaticPath.rawValue
        case .detailRealtime:
            return CTNetworkString.detailRealtimePath.rawValue
        case .commentList:
            return CTNetworkString.commentListPath.rawValue;
        case .guessLike:
            return CTNetworkString.guessLikePath.rawValue;
        case .subscribeList:
            return CTNetworkString.subscribeListPath.rawValue;
		default:
			return ""
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var sampleData: Data {
		return "".data(using: String.Encoding.utf8)!
	}
	
	var task: Task {
		var parammter: [String : Any]! = [:]
		switch self {
		case let .searchHot(param: param):
			parammter = param
		case let .searchRelative(param: param):
			parammter = param
		case let .boutiqueListPath(param: param):
			parammter = param
        case let .vipList(param: param), let .rankList(param: param), let .cateList(param: param), let .searchResult(param: param), let .comicList(param: param), let .detailStatic(param: param), let .detailRealtime(param: param), let .commentList(param: param):
			parammter = param
		default:
			parammter = [:]
		}
		return .requestParameters(parameters: parammter, encoding: URLEncoding.default)
	}
	
	var headers: [String : String]? {
		return nil
	}
}
