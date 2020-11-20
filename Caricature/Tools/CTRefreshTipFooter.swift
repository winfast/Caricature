//
//  CTRefreshTipFooter.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit
import MJRefresh

class CTRefreshTipFooter: MJRefreshBackFooter {

	lazy open var tipLabel : UILabel = {
		let label = UILabel.init()
		label.textAlignment = .center
		label.textColor = .lightGray
		label.font = HZFont(fontSize: 14)
		label.numberOfLines = 0
		return label
	}()
	
	lazy var imageView: UIImageView = {
		let iw = UIImageView()
		iw.image = UIImage(named: "refresh_kiss")
		return iw
	}()
	
	override func prepare() {
		super.prepare()
		self.backgroundColor = self.backgroundColor
		self.mj_h = 240
		self.addSubview(self.tipLabel)
		self.addSubview(self.imageView)
	}
	
	override func placeSubviews() {
		tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
		imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
	}
	
	convenience init(with tip: String) {
		self.init()
		refreshingBlock = { self.endRefreshing() }
		self.refreshingBlock = {
			self.endRefreshing()
		}
		tipLabel.text = tip
	}
}
