//
//  CTRecommendCollectionViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit
import Kingfisher

class CTRecommendCollectionViewCell: UICollectionViewCell {
	open var catureBgImageView: UIImageView?
	open var titleLabel: UILabel = UILabel.init()
	open var subTitleLabel: UILabel = UILabel.init()
	@objc dynamic open var cellViewModel: CTRecommentCellViewModel?

	var disposeBag : DisposeBag = DisposeBag.init()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewsLayout()
		self.createSignal()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		disposeBag = DisposeBag()
//	}
	
	func viewsLayout() -> Void {
		self.catureBgImageView = UIImageView.init()
		self.catureBgImageView?.backgroundColor = .clear
		self.catureBgImageView?.contentMode = .scaleAspectFill
		self.catureBgImageView?.clipsToBounds = true
		self.catureBgImageView?.image = UIImage.init(named: "normal_placeholder_h")
		self.contentView.addSubview(self.catureBgImageView!)
		self.catureBgImageView?.snp.makeConstraints({ (make) in
			make.leading.trailing.top.equalTo(0)
			make.height.equalTo(110)
		})
		
		self.titleLabel.font = HZFont(fontSize: 14)
		self.contentView.addSubview(self.titleLabel)
		self.titleLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(5)
			make.trailing.equalTo(-5)
			make.top.equalTo(self.catureBgImageView!.snp.bottom)
			make.height.equalTo(25)
		}
		
		self.subTitleLabel.font = HZFont(fontSize: 14)
		self.subTitleLabel.textColor = .gray
		self.contentView.addSubview(self.subTitleLabel)
		self.subTitleLabel.snp.makeConstraints { (make) in
			make.leading.trailing.equalTo(self.titleLabel)
			make.top.equalTo(self.titleLabel.snp.bottom)
			make.height.equalTo(25)
		}
	}
	
	func createSignal() -> Void {
		self.rx.observeWeakly(String.self, "cellViewModel.name").filter { (value) -> Bool in
			return true
		}.bind(to: self.titleLabel.rx.text).disposed(by: disposeBag)
		
		self.rx.observeWeakly(String.self, "cellViewModel.subTitle").filter { (value) -> Bool in
			return true
		}.bind(to: self.subTitleLabel.rx.text).disposed(by: disposeBag)
		
		self.rx.observeWeakly(String.self, "cellViewModel.cover").filter({ (value) -> Bool in
			guard let _ = value else {
				return false
			}
			return true
		}).subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.catureBgImageView?.kf.setImage(with: URL.init(string: value!))
		}).disposed(by: disposeBag)
	}
}
