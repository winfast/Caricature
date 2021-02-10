//
//  CTTMonthTicketTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/11.
//

import UIKit

class CTTMonthTicketTableViewCell: UITableViewCell {
    

	lazy private var ticketLabel: UILabel = {
		let label = UILabel.init()
		label.font = HZFont(fontSize: 16)
		label.textAlignment = .center
		label.text = ""
		return label
	}()
	
	@objc dynamic var detailViewModel : CTComicDetaiInfoViewModel?
	private var bag : DisposeBag = DisposeBag.init()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentView.addSubview(self.ticketLabel)
		self.ticketLabel.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.centerY.equalTo(self.contentView.snp.centerY);
			make.right.equalTo(self.contentView.snp.right).offset(-15)
		}
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		bag = DisposeBag()
//	}
	
	func createSignals() -> Void {
		let monthTicket = self.rx.observeWeakly(Int.self, "detailViewModel.monthly_ticket").distinctUntilChanged()
		let totalTicket = self.rx.observeWeakly(Int.self, "detailViewModel.total_ticket").distinctUntilChanged()
		Observable.combineLatest(monthTicket, totalTicket).map { (value) -> NSMutableAttributedString in
			let monthTicketText = value.0 ?? 0
			let totalTicket  = value.1 ?? 0
			let showAttr : NSMutableAttributedString = NSMutableAttributedString.init(string: "本月月票  ", attributes: [NSAttributedString.Key.font : HZFont(fontSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
			let clickTotalAttr : NSAttributedString = NSAttributedString.init(string: String.init(monthTicketText), attributes: [NSAttributedString.Key.font : HZFont(fontSize: 16), NSAttributedString.Key.foregroundColor : UIColor.orange])
			
			let likeAttr : NSAttributedString = NSAttributedString.init(string: "     |     累计月票  ", attributes: [NSAttributedString.Key.font : HZFont(fontSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
			
			let favoriteTotalAttr : NSAttributedString = NSAttributedString.init(string: String.init(totalTicket), attributes: [NSAttributedString.Key.font : HZFont(fontSize: 16), NSAttributedString.Key.foregroundColor : UIColor.orange])
			showAttr.append(clickTotalAttr)
			showAttr.append(likeAttr)
			showAttr.append(favoriteTotalAttr)
			return showAttr
		}.bind(to: self.ticketLabel.rx.attributedText).disposed(by: bag)
	}

}
