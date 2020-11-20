//
//  CTComicDetailHeaderView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/10.
//  214  40

import UIKit
import Kingfisher
import TTGTagCollectionView

class CTComicDetailHeaderView: UIView {
	var comicMaskImageView : UIImageView?
	var comicCoverImagView : UIImageView?
	var comicTitleLabel : UILabel?
	var comicAuthorLabel : UILabel?
	var comiCountLabel : UILabel?
//	var clickCountLabel : UILabel?
//	var clickCountValueLabel : UILabel?
//	var likeLabel: UILabel?
//	var likeCountLabel: UILabel?
	//var comicTypeCollectionView : UICollectionView?
	var tagCollectionView : TTGTextTagCollectionView?
	
	
	@objc dynamic var detailViewModel : CTComicDetaiInfoViewModel?
	private var bag : DisposeBag = DisposeBag.init()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewsLayout()
		self.createSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		
		// 蒙版效果
		self.comicMaskImageView = UIImageView.init(frame: self.bounds)
		self.comicMaskImageView?.backgroundColor = .clear
		self.comicMaskImageView?.contentMode = .scaleAspectFill
		//self.comicMaskImageView?.clipsToBounds = true
		self.addSubview(self.comicMaskImageView!)
//		self.comicMaskImageView?.snp.makeConstraints({ (make) in
//			make.edges.equalTo(0)
//		})
		
		//毛玻璃效果
		let blur = UIBlurEffect.init(style: .dark)
		let effectview = UIVisualEffectView.init(effect: blur)
		let vibrancyEffect = UIVibrancyEffect(blurEffect: blur)
		let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
		effectview.contentView.addSubview(vibrancyView)
		effectview.alpha = 1.0
		self.comicMaskImageView?.addSubview(effectview)
		effectview.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
		
		self.comicCoverImagView = UIImageView.init()
		self.comicCoverImagView?.backgroundColor = .clear
		self.comicCoverImagView?.contentMode = .scaleAspectFill
		self.comicCoverImagView?.image = UIImage.init(named: "normal_placeholder_h")
		self.comicCoverImagView?.clipsToBounds = true
		self.comicCoverImagView?.layer.cornerRadius = 4
		self.comicCoverImagView?.layer.masksToBounds = true
		self.comicCoverImagView?.layer.borderWidth = 1;
		self.comicCoverImagView?.layer.borderColor = UIColor.white.cgColor;
		self.addSubview(self.comicCoverImagView!)
		self.comicCoverImagView?.snp.makeConstraints({ (make) in
			make.left.equalTo(20)
			make.bottom.equalTo(self.snp.bottom).offset(-20)
			make.size.equalTo(CGSize.init(width: 90, height: 120))
		})
		
		self.comicTitleLabel = UILabel.init()
		self.comicTitleLabel?.backgroundColor = .clear
		self.comicTitleLabel?.font = HZFont(fontSize: 16)
		self.comicTitleLabel?.textColor = .white
		self.addSubview(self.comicTitleLabel!)
		self.comicTitleLabel?.snp.makeConstraints({ (make) in
			make.left.equalTo(self.comicCoverImagView!.snp.right).offset(20)
			make.top.equalTo(self.comicCoverImagView!.snp.top)
			make.right.equalTo(self.snp.right).offset(-20).priority(900)
			make.height.equalTo(20)
		})

		self.comicAuthorLabel = UILabel.init()
		self.comicAuthorLabel?.backgroundColor = .clear
		self.comicAuthorLabel?.font = HZFont(fontSize: 13)
		self.comicAuthorLabel?.textColor = .white
		self.addSubview(self.comicAuthorLabel!)
		self.comicAuthorLabel?.snp.makeConstraints({ (make) in
			make.left.equalTo(self.comicTitleLabel!)
			make.size.equalTo(self.comicTitleLabel!.snp.size)
			make.top.equalTo(self.comicTitleLabel!.snp.bottom).offset(5)
		})
		
		self.comiCountLabel = UILabel.init()
		self.comiCountLabel?.backgroundColor = .clear
		self.comiCountLabel?.font = HZFont(fontSize: 16)
		self.comiCountLabel?.textColor = .white
		self.addSubview(self.comiCountLabel!)
		self.comiCountLabel?.snp.makeConstraints({ (make) in
			make.left.equalTo(self.comicAuthorLabel!)
			make.height.equalTo(self.comicAuthorLabel!.snp.height)
			make.top.equalTo(self.comicAuthorLabel!.snp.bottom).offset(10)
		})
		
//		self.clickCountLabel = UILabel.init()
//		self.clickCountLabel?.backgroundColor = .clear
//		self.clickCountLabel?.font = HZFont(fontSize: 14)
//		self.clickCountLabel?.text = "点击"
//		self.clickCountLabel?.textColor = .white
//		self.addSubview(self.clickCountLabel!)
//		self.clickCountLabel?.snp.makeConstraints({ (make) in
//			make.left.equalTo(self.comicAuthorLabel!)
//			//make.height.equalTo(self.comicAuthorLabel!.snp.height)
//			make.bottom.equalTo(self.clickCountLabel!.snp.bottom)
//			make.top.equalTo(self.comicAuthorLabel!.snp.bottom).offset(10)
//		})
//
//		self.clickCountValueLabel = UILabel.init()
//		self.clickCountValueLabel?.backgroundColor = .clear
//		self.clickCountValueLabel?.font = HZFont(fontSize: 15)
//		self.clickCountValueLabel?.textColor = .orange
//		self.addSubview(self.clickCountValueLabel!)
//		self.clickCountValueLabel?.snp.makeConstraints({ (make) in
//			//make.height.equalTo(self.clickCountLabel!)
//			make.left.equalTo(self.clickCountLabel!.snp.right).offset(3)
//			make.bottom.equalTo(self.clickCountLabel!.snp.bottom)
//		})

//		self.likeLabel = UILabel.init()
//		self.likeLabel?.backgroundColor = .clear
//		self.likeLabel?.font = HZFont(fontSize: 14)
//		self.likeLabel?.textColor = .white
//		self.likeLabel?.text = "收藏"
//		self.addSubview(self.likeLabel!)
//		self.likeLabel?.snp.makeConstraints({ (make) in
//			//make.height.equalTo(self.clickCountLabel!.snp.height)
//			make.left.equalTo(self.clickCountValueLabel!.snp.right).offset(8)
//			make.bottom.equalTo(self.clickCountLabel!.snp.bottom)
//		})
//
//		self.likeCountLabel = UILabel.init()
//		self.likeCountLabel?.backgroundColor = .clear
//		self.likeCountLabel?.font = HZFont(fontSize: 15)
//		self.likeCountLabel?.textColor = .orange
//		self.addSubview(self.likeCountLabel!)
//		self.likeCountLabel?.snp.makeConstraints({ (make) in
//			//make.height.equalTo(self.clickCountLabel!.snp.height)
//			make.bottom.equalTo(self.clickCountLabel!.snp.bottom)
//			make.left.equalTo(self.likeLabel!.snp.right).offset(3)
//		})
		
		self.tagCollectionView = TTGTextTagCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: HZSCreenWidth(), height: 200))
		let config = self.tagCollectionView?.defaultConfig
		config?.textFont = HZFont(fontSize: 14)
		config?.textColor = .white
		config?.cornerRadius = 2
		config?.selectedCornerRadius = 2
		config?.borderWidth = 1
		config?.borderColor = .white
		config?.selectedBorderColor = .white
		config?.minWidth = 40
		config?.exactWidth = 40
		config?.exactHeight = 20
		config?.backgroundColor = .clear
		config?.selectedTextColor = .white
		config?.selectedBackgroundColor = .clear
		config?.shadowColor = .clear
		//config.
		self.tagCollectionView?.horizontalSpacing = 10
		self.tagCollectionView?.verticalSpacing = 10
		self.tagCollectionView?.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
		self.tagCollectionView?.selectionLimit = 1
		self.addSubview(self.tagCollectionView!)
	
		self.tagCollectionView?.snp.makeConstraints({ (make) in
			make.left.equalTo(self.comicCoverImagView!.snp.right).offset(20)
			make.right.equalTo(self.snp.right).offset(-20).priority(900)
			make.height.equalTo(30)
			make.bottom.equalTo(self.comicCoverImagView!.snp.bottom)
		})

//		let flowerLayout = UICollectionViewFlowLayout.init()
//		flowerLayout.scrollDirection = .horizontal
//		flowerLayout.itemSize = CGSize.init(width: 40, height: 20)
//		flowerLayout.minimumLineSpacing = 5
//		flowerLayout.minimumInteritemSpacing = 10
//		self.comicTypeCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowerLayout)
//		self.comicTypeCollectionView?.delegate = self;
//		self.comicTypeCollectionView?.dataSource = self;
//		self.comicTypeCollectionView?.backgroundColor = .clear
//		self.comicTypeCollectionView?.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
//		self.addSubview(self.comicTypeCollectionView!)
//		self.comicTypeCollectionView?.snp.makeConstraints({ (make) in
//			make.left.equalTo(self.comicCoverImagView!.snp.right).offset(20)
//			make.right.equalTo(self.snp.right).offset(-20).priority(900)
//			make.height.equalTo(30)
//			make.bottom.equalTo(self.comicCoverImagView!.snp.bottom)
//		})
	}
	
	func createSignals() -> Void {
		self.rx.observeWeakly(String.self, "detailViewModel.name").distinctUntilChanged().bind(to: self.comicTitleLabel!.rx.text).disposed(by: bag)
		self.rx.observeWeakly(String.self, "detailViewModel.authorName").distinctUntilChanged().bind(to: self.comicAuthorLabel!.rx.text).disposed(by: bag)
//		self.rx.observeWeakly(String.self, "detailViewModel.click_total").distinctUntilChanged().bind(to: self.clickCountValueLabel!.rx.text).disposed(by: bag)
//		self.rx.observeWeakly(String.self, "detailViewModel.favorite_total").distinctUntilChanged().bind(to: self.likeCountLabel!.rx.text).disposed(by: bag)
		
		let clickTotalSignal = self.rx.observeWeakly(String.self, "detailViewModel.click_total").distinctUntilChanged()
		let favoriteTotalSignal = self.rx.observeWeakly(String.self, "detailViewModel.favorite_total").distinctUntilChanged()
		Observable.combineLatest(clickTotalSignal, favoriteTotalSignal).map { (value) -> NSAttributedString in
			
			if value.0 == nil {
				return NSMutableAttributedString.init(string: "", attributes: nil)
			}
		
			let clickTotal = value.0 ?? ""
			let favoriteTotal = value.1 ?? ""
			
			let showAttr : NSMutableAttributedString = NSMutableAttributedString.init(string: "点击 ", attributes: [NSAttributedString.Key.font : HZFont(fontSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white])
			let clickTotalAttr : NSAttributedString = NSAttributedString.init(string: clickTotal, attributes: [NSAttributedString.Key.font : HZFont(fontSize: 15), NSAttributedString.Key.foregroundColor : UIColor.orange])
			
			let likeAttr : NSAttributedString = NSAttributedString.init(string: "  收藏 ", attributes: [NSAttributedString.Key.font : HZFont(fontSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white])
			
			let favoriteTotalAttr : NSAttributedString = NSAttributedString.init(string: favoriteTotal, attributes: [NSAttributedString.Key.font : HZFont(fontSize: 15), NSAttributedString.Key.foregroundColor : UIColor.orange])
			showAttr.append(clickTotalAttr)
			showAttr.append(likeAttr)
			showAttr.append(favoriteTotalAttr)
			return showAttr
		}.bind(to: self.comiCountLabel!.rx.attributedText).disposed(by: bag)
		
		
		
		self.rx.observeWeakly(String.self, "detailViewModel.cover").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			guard let valueItem = value else {
				return
			}
			
			weakself.comicCoverImagView?.kf.setImage(with: URL.init(string: valueItem))
		}).disposed(by: bag)
		
		self.rx.observeWeakly(String.self, "detailViewModel.wideCover").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			guard let valueItem = value else {
				return
			}
			
			weakself.comicMaskImageView?.kf.setImage(with: URL.init(string: valueItem))
		}).disposed(by: bag)
		
		self.rx.observeWeakly(Array<String>.self, "detailViewModel.classifyTags").distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
			guard let weakself = self else {
				return
			}
			
			weakself.tagCollectionView?.removeAllTags()
			weakself.tagCollectionView?.addTags(value)
			weakself.tagCollectionView?.reload()
		}).disposed(by: bag)
	}
	
	/// 下拉放大的写法
	/// - Parameter scrollView: scrollerView
	open func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset : CGPoint = scrollView.contentOffset
		if (offset.y >= 0 && offset.y < self.bounds.size.height) {    // iOS13快速下拉，图片在屏幕顶部抖动
			//[self.tableView insertSubview:self.imageView atIndex:0];  // iOS13 需要重新调整self的层级
			self.comicMaskImageView?.transform = .identity;
			self.comicMaskImageView?.center = CGPoint.init(x: self.center.x, y: self.center.y);
		} else {
			self.comicMaskImageView?.center = CGPoint.init(x: self.center.x, y: self.center.y + offset.y * 0.5);
			let x : CGFloat = (self.comicMaskImageView!.bounds.size.height - offset.y)/self.comicMaskImageView!.bounds.size.height;
			self.comicMaskImageView?.transform = CGAffineTransform.init(scaleX: x, y: x);
		}
	}

}
