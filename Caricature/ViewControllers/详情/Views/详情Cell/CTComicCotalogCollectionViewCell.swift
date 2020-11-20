//
//  CTComicCotalogCollectionViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/15.
//

import UIKit

class CTComicCotalogCollectionViewCell: UICollectionViewCell {
	var titleLabel : UILabel = UILabel.init()
	var bag : DisposeBag = DisposeBag.init()
	
	@objc dynamic var cellViewModel : CTChapterCellViewModel?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		bag = DisposeBag()
//	}
	
	func viewsLayout() -> Void {
		self.contentView.backgroundColor = .clear
		self.contentView.layer.cornerRadius = 4
		self.contentView.layer.borderWidth = 1
		self.contentView.layer.borderColor = UIColor.lightGray.cgColor
		
		self.titleLabel.font = HZFont(fontSize: 16)
		self.titleLabel.textColor = .black
		self.contentView.addSubview(self.titleLabel);
		self.titleLabel.snp.makeConstraints { (make) in
			make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10))
		}
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "cellViewModel.name").distinctUntilChanged().bind(to: self.titleLabel.rx.text).disposed(by: bag)
	}
}


class CTComicCotalogFooterCollectionReusableView: UICollectionReusableView {
	
	var contentLabel : UILabel = UILabel.init()
	var sortBtn : UIButton = UIButton.init(type: .custom)

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.viewsLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentLabel.font = HZFont(fontSize: 14)
		self.contentLabel.textColor = .gray
		self.addSubview(self.contentLabel)
		self.contentLabel.snp.makeConstraints { (make) in
			make.left.equalTo(0)
			make.centerY.equalTo(self.snp.centerY)
		}
	}
}
