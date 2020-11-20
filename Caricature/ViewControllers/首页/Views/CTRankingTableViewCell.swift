//
//  CTRankingTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/10/28.
//

import UIKit

class CTRankingTableViewCell: UITableViewCell {
	
	var thumbImageView: UIImageView?
	var titleLabel: UILabel?
	var contentLabel: UILabel?
	
	@objc dynamic open var cellViewModel : CTRankingCellViewModel?
	fileprivate var bag : DisposeBag = DisposeBag.init()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
		self.createSignals()
		return
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		bag = DisposeBag()
//	}
	
	func viewsLayout() -> Void {
		self.thumbImageView = UIImageView.init()
		self.thumbImageView?.backgroundColor = .clear
		self.thumbImageView?.contentMode = .scaleAspectFill
		self.thumbImageView?.image = UIImage.init(named: "normal_placeholder_h")
		self.thumbImageView?.clipsToBounds = true
		self.contentView.addSubview(self.thumbImageView!)
		self.thumbImageView?.snp.makeConstraints({ (make) in
			make.left.top.equalTo(10)
			make.bottom.lessThanOrEqualTo(-10).priority(900)
			make.width.equalTo(self.contentView.snp.width).dividedBy(2)
			make.height.equalTo(HZSCreenWidth() * 0.4 - 20)
		})
		
		self.titleLabel = UILabel.init()
		self.titleLabel?.backgroundColor = .clear
		self.titleLabel?.numberOfLines = 1;
		self.titleLabel?.font = HZFont(fontSize: 18)
		self.titleLabel?.textColor = .black
		self.titleLabel?.text = ""
		self.contentView.addSubview(self.titleLabel!)
		self.titleLabel?.snp.makeConstraints({ (make) in
			make.left.equalTo(self.thumbImageView!.snp.right).offset(10)
			make.top.equalTo(self.thumbImageView!.snp.top).offset(20)
		})
		
		self.contentLabel = UILabel.init()
		self.contentLabel?.backgroundColor = .clear
		self.contentLabel?.numberOfLines = 2
		self.contentLabel?.textColor = .gray
		self.contentLabel?.font = HZFont(fontSize: 14)
		self.contentLabel?.text = ""
		self.contentView.addSubview(self.contentLabel!)
		self.contentLabel?.snp.makeConstraints({ (make) in
			make.left.equalTo(self.titleLabel!.snp.left).offset(0)
			make.right.equalTo(self.contentView.snp.right).offset(-10)
			make.top.equalTo(self.titleLabel!.snp.bottom).offset(10)
			make.bottom.equalTo(self.thumbImageView!.snp.bottom)
		})
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "cellViewModel.title").filter { (value) -> Bool in
			guard let _ = value else {
				return false
			}
			return true
		}.map { (value) -> String in
			return value! + "榜"
		}.bind(to: self.titleLabel!.rx.text).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "cellViewModel.subTitle").filter { (value) -> Bool in
			guard let _ = value else {
				return false
			}
			return true
		}.bind(to: self.contentLabel!.rx.text).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "cellViewModel.cover").filter({ (value) -> Bool in
			guard let _ = value else {
				return false
			}
			return true
		}).subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			weakself.thumbImageView?.kf.setImage(with: URL.init(string: value!))
		}).disposed(by: bag)
	}
	
}
