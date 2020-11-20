//
//  CTWorkingDesTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/11.
//

import UIKit

class CTWorkingDesTableViewCell: UITableViewCell {

	lazy private var comicTitleLabel: UILabel = {
		let label = UILabel.init()
		label.text = "作品介绍"
		return label
	}()
	
	lazy var comicDesLabel: UILabel = {
		let label = UILabel.init()
		label.textColor = .gray
		label.font = HZFont(fontSize: 15)
		label.numberOfLines = 0
		return label
	}()
	
	@objc dynamic var detailViewModel : CTComicDetaiInfoViewModel?
	private var bag : DisposeBag = DisposeBag.init()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentView.addSubview(self.comicTitleLabel)
		self.comicTitleLabel.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.top.equalTo(15);
			make.right.equalTo(self.contentView.snp.right).offset(-15)
		}
		
		self.contentView.addSubview(self.comicDesLabel)
		self.comicDesLabel.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.top.equalTo(self.comicTitleLabel.snp.bottom).offset(5);
			make.right.equalTo(self.contentView.snp.right).offset(-15)
			make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-15).priority(900)
		}
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		bag = DisposeBag()
//	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "detailViewModel.workDescription").distinctUntilChanged().bind(to: self.comicDesLabel.rx.text).disposed(by: bag)
	}
}
