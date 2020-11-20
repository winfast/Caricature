//
//  UIView+Toast.swift
//  HZTT
//
//  Created by Sam on 2020/8/24.
//  Copyright © 2020 Galanz. All rights reserved.
//

import Foundation

public extension UIView {
    
    func showToast(str :String) -> () {
    }
}

public extension UIView {
	func ct_prepareToShow() -> Void {
		self.alpha = 0.0
	}
	
	func ct_makeVisble() -> Void {
		if self.alpha == 1.0 {
			return
		}
		UIView.animate(withDuration: 0.25) {
			self.alpha = 1.0
		}
	}
}
