//
//  CTOtherWorkingTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/11.
//

import UIKit

class CTOtherWorkingTableViewCell: UITableViewCell {

	lazy private var otherComicLabel: UILabel = {
		let label = UILabel.init()
		label.font = HZFont(fontSize: 16)
		label.text = "其他作品"
		return label
	}()
	
	@objc dynamic var viewModel : CTComicDetailViewModel?
	private var bag : DisposeBag = DisposeBag.init()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .value1, reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentView.addSubview(self.otherComicLabel)
		self.otherComicLabel.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.centerY.equalTo(self.contentView.snp.centerY);
			make.right.equalTo(self.contentView.snp.right).offset(-15)
		}
		
		self.detailTextLabel?.text = "4本"
		self.detailTextLabel?.font = HZFont(fontSize: 14)
		self.detailTextLabel?.textColor = .gray
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		bag = DisposeBag()
//	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(Array<CTOtherWorkCellViewModel>.self, "viewModel.comicOtherWorkingDataSource").distinctUntilChanged().map { (value) -> String in
			if value == nil || value!.count == 0 {
				return ""
			} else {
				return "\(value!.count) 本"
			}
		}.bind(to: self.detailTextLabel!.rx.text).disposed(by: bag)
	}

}
