//
//  CTSearchResultTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/9.
//

import UIKit
import Kingfisher

class CTSearchResultTableViewCell: UITableViewCell {
	
	var coverImageView : UIImageView?
	var catureTitleLabel : UILabel?
	var catureTypeLabel : UILabel?
	var catureContentLabel : UILabel?
	var readCountLabel: UILabel?
	var iconIamgView : UIImageView?
	
	@objc dynamic var cellViewModel : CTSearchResltCellViewModel?
	fileprivate var bag : DisposeBag = DisposeBag.init()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		bag = DisposeBag()
	}
	/*
	var viewModel: CartSubViewModel?{

		 didSet{

			 if let vm = viewModel{

				 let disposeBag = DisposeBag()

				 

				 vm.numText.asObservable()

					 .bindTo(numField.rx.text)

					 .addDisposableTo(disposeBag)

				 

				 self.disposeBag = disposeBag

			 }

		 }

	 }


	 override func prepareForReuse() {

		 super.prepareForReuse()

		 self.disposeBag = nil

	 }
	*/
	
	func viewsLayout() -> Void {
		self.coverImageView = UIImageView.init()
		self.coverImageView?.backgroundColor = .clear
		self.coverImageView?.contentMode = .scaleAspectFill
		self.coverImageView?.clipsToBounds = true
		self.coverImageView?.image = UIImage.init(named: "normal_placeholder_h")
		self.contentView.addSubview(self.coverImageView!)
		self.coverImageView?.snp.makeConstraints({ (make) in
			make.leading.top.equalTo(10)
			make.bottom.lessThanOrEqualTo(-10).priority(900)
			make.height.equalTo(160)
			make.width.equalTo(100)
		})
		
		self.catureTitleLabel = UILabel.init()
		self.catureTitleLabel?.backgroundColor = .clear
		self.catureTitleLabel?.font = HZFont(fontSize: 17)
		self.catureTitleLabel?.textColor = .black
		self.contentView.addSubview(self.catureTitleLabel!)
		self.catureTitleLabel?.snp.makeConstraints({ (make) in
			make.top.equalTo(self.coverImageView!.snp.top)
			make.left.equalTo(self.coverImageView!.snp.right).offset(10)
			make.right.equalTo(self.contentView.snp.right).offset(-10)
			make.height.equalTo(30)
		})
		
		self.catureTypeLabel = UILabel.init()
		self.catureTypeLabel?.backgroundColor = .clear
		self.catureTypeLabel?.font = HZFont(fontSize: 14)
		self.catureTypeLabel?.textColor = .gray
		self.contentView.addSubview(self.catureTypeLabel!)
		self.catureTypeLabel?.snp.makeConstraints({ (make) in
			make.top.equalTo(self.catureTitleLabel!.snp.bottom).offset(5)
			make.left.equalTo(self.catureTitleLabel!.snp.left)
			make.right.equalTo(self.catureTitleLabel!.snp.right)
			make.height.equalTo(20)
		})
		
		self.catureContentLabel = UILabel.init()
		self.catureContentLabel?.backgroundColor = .clear
		self.catureContentLabel?.font = HZFont(fontSize: 14)
		self.catureContentLabel?.textColor = .gray
		self.catureContentLabel?.numberOfLines = 3
		self.contentView.addSubview(self.catureContentLabel!)
		self.catureContentLabel?.snp.makeConstraints({ (make) in
			make.top.equalTo(self.catureTypeLabel!.snp.bottom).offset(5)
			make.left.equalTo(self.catureTitleLabel!.snp.left)
			make.right.equalTo(self.catureTitleLabel!.snp.right)
			make.height.equalTo(60)
		})
		
		self.readCountLabel = UILabel.init()
		self.readCountLabel?.backgroundColor = .clear
		self.readCountLabel?.font = HZFont(fontSize: 14)
		self.readCountLabel?.textColor = UIColorWith24Hex(rgbValue: 0xFF7B00)
		self.contentView.addSubview(self.readCountLabel!)
		self.readCountLabel?.snp.makeConstraints({ (make) in
			make.bottom.equalTo(self.coverImageView!.snp.bottom).offset(0)
			make.left.equalTo(self.catureTitleLabel!.snp.left)
			make.right.equalTo(self.catureTitleLabel!.snp.right)
			make.height.equalTo(20)
		})
	}

	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "cellViewModel.name").observeOn(MainScheduler.instance).filter({ (value) -> Bool in
			guard let _ = value else {
				return false
			}
			return true
		}).bind(to: self.catureTitleLabel!.rx.text).disposed(by: bag)
		
		let observeAuthor : Observable<String?> = self.rx.observeWeakly(String.self, "cellViewModel.author").distinctUntilChanged()
		let observeTags : Observable<String?> = self.rx.observeWeakly(String.self, "cellViewModel.tags").distinctUntilChanged()
		Observable.combineLatest(observeAuthor, observeTags).subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}

			var author : String? = value.0
			var tags : String? = value.1

			if author == nil {
				author = ""
			}

			if tags == nil {
				tags = ""
			}

			weakself.catureTypeLabel?.text = tags! + " | " + author!

		}).disposed(by: bag)

		self.rx.observeWeakly(String.self, "cellViewModel.descriptionValue").distinctUntilChanged().bind(to: (self.catureContentLabel?.rx.text)!).disposed(by: bag)
		self.rx.observeWeakly(String.self, "cellViewModel.clickTotal").distinctUntilChanged().bind(to: (self.readCountLabel?.rx.text)!).disposed(by: bag)
		self.rx.observeWeakly(String.self, "cellViewModel.cover").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}

			if value == nil || value!.lengthOfBytes(using: .utf8) == 0 {
				return
			}

			weakself.coverImageView?.kf.setImage(with: URL.init(string: value!))
		}).disposed(by: bag)
	}
}
