//
//  CTAllSearchTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/6.
//

import UIKit
import TTGTagCollectionView

class CTAllSearchTableViewCell: UITableViewCell {
	
	fileprivate var tagCollectionView : TTGTextTagCollectionView?
	fileprivate var bag : DisposeBag = DisposeBag.init()
	
	typealias CTSelectedSearchKeyword = (_ selectedIndex : Int) -> Void
	var selectedSearchKeyWord : CTSelectedSearchKeyword?
	
	@objc dynamic open var cellViewModel : CTSearchViewModel?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		
		let lineView = UIView.init(frame: .zero)
		lineView.backgroundColor = .lightGray
		self.contentView.addSubview(lineView)
		lineView.snp.makeConstraints { (make) in
			make.left.top.right.equalTo(0)
			make.height.equalTo(1)
		}
		
		
		self.selectionStyle = .none;
		self.contentView.backgroundColor = .white
		self.tagCollectionView = TTGTextTagCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: HZSCreenWidth(), height: 200))
		self.tagCollectionView?.delegate = self
		let config = self.tagCollectionView?.defaultConfig
		config?.textFont = HZFont(fontSize: 14)
		config?.textColor = .darkGray
		config?.cornerRadius = 18.5
		config?.selectedCornerRadius = 18.5
		config?.borderWidth = 1
		config?.borderColor = CTBackgroundColor()
		config?.selectedBorderColor = CTBackgroundColor()
		config?.minWidth = 80
		//config?.extraSpace = CGSize.init(width: 35, height: 10)
		config?.exactHeight = 37
		config?.backgroundColor = .clear
		config?.selectedTextColor = .darkGray
		config?.selectedBackgroundColor = .clear
		config?.shadowColor = .clear
		//config.
		self.tagCollectionView?.horizontalSpacing = 10
		self.tagCollectionView?.verticalSpacing = 10
		self.tagCollectionView?.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
		//self.tagCollectionView?.addTags(["1","2","3","5","45624564564","asdfasdfasdf","234234","asdfasdfas","asdfasdf","41564","fasdf2sdfasdf"])
		self.tagCollectionView?.selectionLimit = 1
		self.contentView.addSubview(self.tagCollectionView!)
		
		//print(self.tagCollectionView?.contentSize)
		
		self.tagCollectionView?.snp.remakeConstraints({ (make) in
			make.left.right.top.equalTo(0)
			make.bottom.lessThanOrEqualTo(0).priority(900)
			make.height.equalTo(155)
		})
	}
	
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		bag = DisposeBag()
//	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(Array<String>.self, "cellViewModel.searchHotDataSource").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			if value?.count == 0 {
				return
			}
			
			weakself.tagCollectionView?.removeAllTags()
			weakself.tagCollectionView?.addTags(value)
			weakself.tagCollectionView?.reload()
		}).disposed(by: bag)
	}
}

extension CTAllSearchTableViewCell: TTGTextTagCollectionViewDelegate {
	func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
		if selected == false {
			return
		}
		
		if self.selectedSearchKeyWord != nil {
			self.selectedSearchKeyWord!(Int.init(index))
		}
	}
}
