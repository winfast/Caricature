//
//  CTCommentTableViewCell.swift
//  Caricature
//
//  Created by Qincc on 2021/1/30.
//

import UIKit
import Kingfisher

class CTCommentTableViewCell: UITableViewCell {
    
    @objc dynamic var cellViewModel : CTCommentCellViewModel?
    var bag : DisposeBag = DisposeBag.init()
    
    lazy var userIconImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = .gray
        label.font = HZFont(fontSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    lazy var commentContentLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = .black
        label.font = HZFont(fontSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var lineView: UIView = {
        let view : UIView = UIView.init()
        view.backgroundColor = .lightGray
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.viewsLayout()
        self.bindSignals()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindSignals() -> Void {
        self.rx.observeWeakly(String.self, "cellViewModel.nickname").distinctUntilChanged().bind(to: self.userNameLabel.rx.text).disposed(by: bag)
        self.rx.observeWeakly(String.self, "cellViewModel.content_filter").distinctUntilChanged().bind(to: self.commentContentLabel.rx.text).disposed(by: bag)
        self.rx.observeWeakly(String.self, "cellViewModel.face").distinctUntilChanged().filter({ (value) -> Bool in
            guard let _ = value else {
                return false
            }
            return true
        }).subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }
            
            weakself.userIconImageView.kf.setImage(with: URL.init(string: value!))
        }).disposed(by: bag)
    }
    
    func viewsLayout() -> Void {
        self.contentView.addSubview(self.userIconImageView)
        self.userIconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(8)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
        
        self.contentView.addSubview(self.userNameLabel)
        self.userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userIconImageView.snp.top)
            make.left.equalTo(self.userIconImageView.snp.right).offset(8);
        }
        
        self.contentView.addSubview(self.commentContentLabel)
        self.commentContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(16)
            make.left.equalTo(self.userIconImageView.snp.right).offset(8)
            make.right.equalTo(self.contentView.snp.right).offset(-12)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-16).priority(900);
        }
        
        self.contentView.addSubview(self.lineView);
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.left.equalTo(16)
            make.height.equalTo(0.5)
        }
    }
}
