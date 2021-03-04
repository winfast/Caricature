//
//  CTSubscriberCollectionViewCell.swift
//  Caricature
//
//  Created by Qincc on 2021/3/4.
//

import UIKit


class CTSubscriberHeaderCollectionReusableView: UICollectionReusableView {
    //MVVM
    @objc dynamic var sectionViewModel : CTSubsciberSectionViewModel?
    
    lazy open var iconImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.backgroundColor = .clear
        imageView.image = UIImage.init(named: "normal_placeholder_v")
        return imageView
    }()
    
    open var titleLabel: UILabel = UILabel.init()
    open var moreBtn: UIButton = UIButton.init(type: .custom)
    
    typealias CTClickMoreBntBlock = (_ sender: UIButton) -> Void
    open var clickMoreBntBlock : CTClickMoreBntBlock?
    
    fileprivate let disposeBag : DisposeBag = DisposeBag.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewsLayout()
        self.createSignals()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewsLayout() -> Void {
        self.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.titleLabel.font = HZFont(fontSize: 14)
        self.titleLabel.textColor = .black
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(5)
            make.height.equalTo(self.iconImageView.snp.height)
            make.centerY.equalTo(self.iconImageView.snp.centerY)
        }
        
        self.moreBtn.setTitle("•••", for: .normal)
        self.moreBtn.setTitleColor(.lightGray, for: .normal)
        self.moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.moreBtn.rx.tap
            .subscribe(onNext: { [weak self] () in
                guard let weakself = self else {
                    return
                }
                
                //执行操作
                if weakself.clickMoreBntBlock != nil {
                    weakself.clickMoreBntBlock!(weakself.moreBtn)
                }
            })
            .disposed(by: disposeBag)
        self.addSubview(self.moreBtn)
        self.moreBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 44, height: 44))
            make.right.top.equalTo(0)
        }
    }
    
    func createSignals() -> Void {
        self.rx.observeWeakly(String.self, "sectionViewModel.itemTitle").distinctUntilChanged()
            .filter { (value) -> Bool in
                guard let _  = value else {
                    return false
                }
                return true
            }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.rx.observeWeakly(String.self, "sectionViewModel.newTitleIconUrl").distinctUntilChanged().filter { (value) -> Bool in
            guard let _  = value else {
                return false
            }
            return true
        }.subscribe { (value) in
            self.iconImageView.kf.setImage(with: URL.init(string: value!))
        }.disposed(by: disposeBag)
    }
}


class CTSubscriberCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = HZFont(fontSize: 12)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewsLayout() -> Void {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0);
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.top.equalTo(imageView.snp.bottom)
            make.width.equalTo(contentView.snp.width).offset(-20)
            make.height.equalTo(20)
        }
    }
    
    func bindSignals() -> Void {
        
    }
}
