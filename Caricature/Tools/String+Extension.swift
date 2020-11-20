//
//  String+Extension.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/15.
//

import Foundation

extension String  {
	static func showTimeFrom(timeStamp : Int, formatTime : String) -> String? {
		let date = Date.init(timeIntervalSince1970: TimeInterval.init(timeStamp))   //时间转换出来
		let dateFormat = DateFormatter.init()
		dateFormat.dateFormat = formatTime
		return dateFormat.string(from: date)
	}
}
