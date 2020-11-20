//
//  CTRecommendHeadCollectionReusableView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit

class CTRecommendHeaderCollectionReusableView: UICollectionReusableView {
	//MVVM
	@objc dynamic var sectionViewModel : CTRecommentSectionViewModel?
	
	lazy open var iconImageView: UIImageView = {
		let imageView = UIImageView.init()
		imageView.backgroundColor = .clear
		imageView.image = UIImage.init(named: "normal_placeholder_v")
		return imageView
	}()
	
	open var titleLabel: UILabel = UILabel.init()
	open var moreBtn: UIButton = UIButton.init(type: .custom)
	
	typealias CTClickMoreBntBlock = (_ sender: UIButton) -> Void
	open var clickMoreBntBlock : CTClickMoreBntBlock?
	
	fileprivate let disposeBag : DisposeBag = DisposeBag.init()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.addSubview(self.iconImageView)
		self.iconImageView.snp.makeConstraints { (make) in
			make.left.equalTo(5)
			make.size.equalTo(CGSize.init(width: 40, height: 40))
			make.centerY.equalTo(self.snp.centerY)
		}
		
		self.titleLabel.font = HZFont(fontSize: 14)
		self.titleLabel.textColor = .black
		self.addSubview(self.titleLabel)
		self.titleLabel.snp.makeConstraints { (make) in
			make.left.equalTo(self.iconImageView.snp.right).offset(5)
			make.height.equalTo(self.iconImageView.snp.height)
			make.centerY.equalTo(self.iconImageView.snp.centerY)
		}
		
		self.moreBtn.setTitle("•••", for: .normal)
		self.moreBtn.setTitleColor(.lightGray, for: .normal)
		self.moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
		self.moreBtn.rx.tap
			.subscribe(onNext: { [weak self] () in
				guard let weakself = self else {
					return
				}
				
				//执行操作
				if weakself.clickMoreBntBlock != nil {
					weakself.clickMoreBntBlock!(weakself.moreBtn)
				}
			})
			.disposed(by: disposeBag)
		self.addSubview(self.moreBtn)
		self.moreBtn.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize.init(width: 44, height: 44))
			make.right.top.equalTo(0)
		}
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "sectionViewModel.itemTitle").distinctUntilChanged()
			.filter { (value) -> Bool in
				guard let _  = value else {
					return false
				}
				return true
			}
			.bind(to: self.titleLabel.rx.text)
			.disposed(by: disposeBag)
		
		self.rx.observeWeakly(String.self, "sectionViewModel.newTitleIconUrl").distinctUntilChanged().filter { (value) -> Bool in
			guard let _  = value else {
				return false
			}
			return true
		}.subscribe { (value) in
			self.iconImageView.kf.setImage(with: URL.init(string: value!))
		}.disposed(by: disposeBag)
	}
}
