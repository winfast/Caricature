//
//  CTCateListCollectionViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit

class CTCateListCollectionViewCell: UICollectionViewCell {
	
	@objc dynamic open var cellViewModel : CTCateListCellViewModel?
	fileprivate var bag : DisposeBag = DisposeBag.init()
	
	
	lazy var iconImageView: UIImageView = {
		let imageView = UIImageView.init()
		imageView.contentMode = .scaleAspectFill
		imageView.image = UIImage.init(named: "normal_placeholder_h")
		imageView.clipsToBounds = true
		return imageView
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel.init()
		label.textColor = .black
		label.font = HZFont(fontSize: 14)
		label.textAlignment = .center
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewsLayout()
		self.createSignals()
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		bag = DisposeBag()
//	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentView.layer.cornerRadius = 5
		self.contentView.layer.borderWidth = 1
		self.contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
		self.contentView.layer.masksToBounds = true
	
		self.contentView.addSubview(self.iconImageView)
		self.iconImageView.snp.makeConstraints {
			$0.top.leading.trailing.equalTo(0)
			$0.bottom.equalTo(self.contentView.snp.bottom).offset(-25)
		}
		
		self.titleLabel.text = ""
		self.contentView.addSubview(self.titleLabel)
		self.titleLabel.snp.makeConstraints { (make) in
			make.leading.trailing.bottom.equalTo(0)
			make.top.equalTo(self.iconImageView.snp.bottom)
		}
	}
	
	func createSignals() -> Void {
		self.rx.observe(String.self, "cellViewModel.sortName").distinctUntilChanged().bind(to: self.titleLabel.rx.text).disposed(by: bag)
		
		self.rx.observe(String.self, "cellViewModel.cover").distinctUntilChanged().filter({ (value) -> Bool in
			guard let _ = value else {
				return false
			}
			return true
		}).subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.iconImageView.kf.setImage(with: URL.init(string: value!))
		}).disposed(by: bag)
	}
	
}
