//
//  CTLikeComicTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/11.
//

import UIKit

class CTLikeComicTableViewCell: UITableViewCell {
	
	lazy private var comicTitleLabel: UILabel = {
		let label = UILabel.init()
		label.text = "猜你喜欢"
		return label
	}()
	
	var comicsCollectionView : UICollectionView?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.viewsLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.contentView.addSubview(self.comicTitleLabel)
		self.comicTitleLabel.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.top.equalTo(15);
		}
		
		let flowerLayout = UICollectionViewFlowLayout.init()
		flowerLayout.scrollDirection = .vertical
		flowerLayout.itemSize = CGSize.init(width: (HZSCreenWidth() - 50)/4.0, height: 150)
		flowerLayout.minimumLineSpacing = 10
		flowerLayout.minimumInteritemSpacing = 10
		self.comicsCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowerLayout)
		self.comicsCollectionView?.delegate = self;
		self.comicsCollectionView?.dataSource = self;
		self.comicsCollectionView?.backgroundColor = .clear
		self.comicsCollectionView?.register(CTLickComicCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CTLickComicCollectionViewCell")
		self.comicsCollectionView?.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
		self.contentView.addSubview(self.comicsCollectionView!)
		self.comicsCollectionView?.snp.makeConstraints({ (make) in
			make.top.equalTo(self.comicTitleLabel.snp.top).offset(5)
			make.left.equalTo(0)
			make.right.equalTo(0)
			make.height.equalTo(160)
			make.bottom.lessThanOrEqualTo(0).priority(900)
		})
	}
}

extension CTLikeComicTableViewCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return UICollectionViewCell.init()
	}
}

class CTLickComicCollectionViewCell : UICollectionViewCell {
	var comicConverImagView : UIImageView?
	var comicTitleLabel : UILabel?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewsLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	func viewsLayout() -> Void {
		self.comicConverImagView = UIImageView.init()
		self.comicConverImagView?.contentMode = .scaleAspectFill
		self.comicConverImagView?.clipsToBounds = true
		self.comicConverImagView?.image = UIImage.init(named: "normal_placeholder_v")
		self.contentView.addSubview(self.comicConverImagView!)
		self.comicConverImagView?.snp.makeConstraints({ (make) in
			make.left.right.top.equalTo(0)
			make.height.equalTo(115)
		})
		
		self.comicTitleLabel = UILabel.init()
		self.contentView.addSubview(self.comicTitleLabel!)
		self.comicTitleLabel?.snp.makeConstraints({ (make) in
			make.top.equalTo(self.comicConverImagView!.snp.bottom)
			make.centerX.equalTo(self.contentView.snp.centerX)
			make.width.equalTo(self.contentView.snp.width).multipliedBy(0.85)
		})
	}
	
}

