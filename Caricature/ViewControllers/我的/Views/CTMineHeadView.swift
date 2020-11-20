//
//  CTMineHeadView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit

class CTMineHeadView: UIView {
	
	var contentImageView : UIImageView = UIImageView.init()

	override init(frame: CGRect) {
		super.init(frame: frame)
		viewsLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentImageView.backgroundColor = .clear
		self.contentImageView.image = UIImage.init(named: "mine_bg_for_boy")
		self.contentImageView.contentMode = .scaleAspectFill
		self.contentImageView.frame = self.bounds
		self.addSubview(self.contentImageView)
	}
	
	
	/// 下拉放大的写法
	/// - Parameter scrollView: scrollerView
	open func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset : CGPoint = scrollView.contentOffset
		if (offset.y >= 0 && offset.y < self.bounds.size.height) {    // iOS13快速下拉，图片在屏幕顶部抖动
			//[self.tableView insertSubview:self.imageView atIndex:0];  // iOS13 需要重新调整self的层级
			self.contentImageView.transform = .identity;
			self.contentImageView.center = CGPoint.init(x: self.center.x, y: self.center.y);
		} else {
			self.contentImageView.center = CGPoint.init(x: self.center.x, y: self.center.y + offset.y * 0.5);
			let x : CGFloat = (self.contentImageView.bounds.size.height - offset.y)/self.contentImageView.bounds.size.height;
			self.contentImageView.transform = CGAffineTransform.init(scaleX: x, y: x);
		}
	}
}
