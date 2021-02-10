//
//  CTLikeComicTableViewCell.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/11.
//

import UIKit
import Kingfisher

class CTLikeComicTableViewCell: UITableViewCell {
    
    typealias CTSelectedGuessLikeComic = (_ indexPath: IndexPath) -> Void
    open var selectedGuessLikeComic : CTSelectedGuessLikeComic?
	
	lazy private var comicTitleLabel: UILabel = {
		let label = UILabel.init()
		label.text = "猜你喜欢"
		return label
	}()
    
   @objc dynamic var detailViewModel: CTComicDetailViewModel? {
        didSet {
            comicsCollectionView?.reloadData()
        }
    }
	
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
			make.top.equalTo(15)
		}
		
		let flowerLayout = UICollectionViewFlowLayout.init()
		flowerLayout.scrollDirection = .vertical
		flowerLayout.itemSize = CGSize.init(width: (HZSCreenWidth() - 50)/4.0, height: 140)
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
			make.top.equalTo(self.comicTitleLabel.snp.bottom).offset(5)
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
        let count: Int = self.detailViewModel?.guessLikeComicDataSource?.count ?? 0
        if count > 4{
            return 4
        }
        return self.detailViewModel?.guessLikeComicDataSource?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CTLickComicCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTLickComicCollectionViewCell", for: indexPath) as! CTLickComicCollectionViewCell
        cell.cellViewModel = self.detailViewModel?.guessLikeComicDataSource?[indexPath.item]
        return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let callbalk: CTSelectedGuessLikeComic = self.selectedGuessLikeComic else {
            return
        }
        
        callbalk(indexPath)
    }
}

class CTLickComicCollectionViewCell : UICollectionViewCell {
	var comicConverImagView : UIImageView?
	var comicTitleLabel : UILabel?
    let bag: DisposeBag = DisposeBag.init()
    
    @objc dynamic var cellViewModel: CTGuessLikeComicCellViewModel?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewsLayout()
        self.bindSignals()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    func bindSignals() -> Void {
        self.rx.observeWeakly(String.self, "cellViewModel.cover").distinctUntilChanged().filter { (value) -> Bool in
            guard let _ = value else {
                return false
            }
            return true
        }.subscribe(onNext: {[weak self] (value) in
            guard let weakself = self else {
                return
            }
            
            weakself.comicConverImagView?.kf.setImage(with: URL.init(string: value!))
        }).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "cellViewModel.name").distinctUntilChanged().filter { (value) -> Bool in
            guard let _ = value else {
                return false
            }
            return true
        }.bind(to: self.comicTitleLabel!.rx.text).disposed(by: bag)
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
        self.comicTitleLabel?.font = HZFont(fontSize: 14)
		self.contentView.addSubview(self.comicTitleLabel!)
		self.comicTitleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.comicConverImagView!.snp.bottom).offset(5)
			make.centerX.equalTo(self.contentView.snp.centerX)
			make.width.equalTo(self.contentView.snp.width).multipliedBy(0.85)
		})
	}
	
}

