//
//  CTSearchHeaderTableView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/6.
//

import UIKit

class CTSearchHeaderTableView: UITableViewHeaderFooterView {
	var titleLabel : UILabel?
	var rightBtn: UIButton?
	
	typealias CTClickSearchHeaderView = (_ sender: UIButton) -> (Void)
	var clickSearchHeaderView : CTClickSearchHeaderView?
	fileprivate let bag : DisposeBag = DisposeBag.init()
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentView.backgroundColor = .white
		self.titleLabel = UILabel.init()
		self.titleLabel?.backgroundColor = .clear
		self.titleLabel?.font = HZFont(fontSize: 14)
		self.titleLabel?.textColor = .lightGray
		self.contentView.addSubview(self.titleLabel!)
		self.titleLabel?.snp.makeConstraints({ (make) in
			make.left.equalTo(10)
			make.centerY.equalTo(self.snp.centerY)
		})
		
		self.rightBtn = UIButton.init(type: .custom)
		self.rightBtn?.backgroundColor = .clear
		self.rightBtn?.rx.tap.subscribe(onNext: { [weak self] in
			guard let weakself = self else {
				return
			}
			
			if weakself.clickSearchHeaderView != nil {
				weakself.clickSearchHeaderView!(weakself.rightBtn!)
			}
			
		}).disposed(by: bag)
		self.contentView.addSubview(self.rightBtn!)
		self.rightBtn?.snp.makeConstraints({ (make) in
			make.right.equalTo(self.snp.right).offset(-5);
			make.centerY.equalTo(self.snp.centerY)
		})
	}

}
