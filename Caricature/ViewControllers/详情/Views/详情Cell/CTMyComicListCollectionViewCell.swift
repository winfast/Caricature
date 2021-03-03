//
//  CTMyComicListCollectionViewCell.swift
//  Caricature
//
//  Created by Qincc on 2021/2/9.
//

import UIKit
import Kingfisher

class CTMyComicListCollectionViewCell: UICollectionViewCell {
    
    @objc dynamic var cellViewModel: CTOtherWorkCellViewModel?
    fileprivate let bag: DisposeBag = DisposeBag.init()
    
    lazy var comicCoverImageView: UIImageView = {
        var imageView = UIImageView.init()
        return imageView
    }()
    
    lazy var comicNameLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = .black
        label.font = HZFont(fontSize: 14)
        return label
    }()
    
    lazy var comicUpdateLabel: UILabel = {
        var label = UILabel.init()
        label.textColor = .gray
        label.font = HZFont(fontSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewsLayout()
        self.bindSignals()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewsLayout() -> Void {
        self.contentView.addSubview(self.comicCoverImageView)
        self.comicCoverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(self.contentView.snp.width).multipliedBy(155/111.0)
        }
        
        self.contentView.addSubview(self.comicNameLabel)
        self.comicNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.comicCoverImageView.snp.bottom)
            make.height.equalTo(25)
            make.left.equalTo(10)
            make.width.lessThanOrEqualTo(self.contentView.snp.width).multipliedBy(0.8).priority(900)
        }
        
        self.contentView.addSubview(self.comicUpdateLabel)
        self.comicUpdateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.comicNameLabel.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(self.comicNameLabel.snp.left)
            make.width.equalTo(self.comicNameLabel.snp.width)
        }
    }
    
    func bindSignals() -> Void {
        self.rx.observeWeakly(String.self, "cellViewModel.coverUrl").distinctUntilChanged().filter { (value) -> Bool in
            guard let _  = value else {
                return false
            }
            return true
        }.subscribe(onNext: { (value) in
            self.comicCoverImageView.kf.setImage(with: URL.init(string: value!))
        }).disposed(by: bag)
        
        
        self.rx.observeWeakly(String.self, "cellViewModel.name").distinctUntilChanged().filter { (value) -> Bool in
            guard let _  = value else {
                return false
            }
            return true
        }.bind(to: self.comicNameLabel.rx.text).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "cellViewModel.passChapterNum").distinctUntilChanged().filter { (value) -> Bool in
            guard let _  = value else {
                return false
            }
            return true
        }.map { (value) -> String in
            return String.init(format: "更新至%@话", value!)
        }.bind(to: self.comicUpdateLabel.rx.text).disposed(by: bag)
    }
}
