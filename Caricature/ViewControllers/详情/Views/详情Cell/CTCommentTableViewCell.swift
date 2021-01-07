//
//  CTCommentTableViewCell.swift
//  Caricature
//
//  Created by Qincc on 2021/1/7.
//

import UIKit
import Kingfisher

class CTCommentTableViewCell: UITableViewCell {
    
    var cellViewModel : CTCommentCellViewModel?
    
    var userIconImageView : UIImageView?
    var userNameLabel : UILabel?
    var userContentLabel : UILabel?
    
    var bag : DisposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.viewsLayout()
        self.createSignals()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewsLayout() -> Void {
        self.userIconImageView = UIImageView.init()
        self.userIconImageView?.backgroundColor = .clear
        self.contentView.addSubview(self.userIconImageView!);
        self.userIconImageView?.snp.makeConstraints({ (make) in
            
        })
    }
    
    func createSignals() -> Void {
        self.rx.observeWeakly(String.self, "cellViewModel.face").distinctUntilChanged().filter({ (value) -> Bool in
            guard let _ = value else  {
                return false
            }
            return true
        }).subscribe(onNext: { [weak self] (value) in
            guard let weakself = self else {
                return
            }

            weakself.userIconImageView?.kf.setImage(with: URL.init(string: value!))
        }).disposed(by: bag)
        
        self.rx.observeWeakly(String.self, "cellViewModel.content_filter").distinctUntilChanged().bind(to: self.userContentLabel!.rx.text).disposed(by: bag)
        self.rx.observeWeakly(String.self, "cellViewModel.nickname").distinctUntilChanged().bind(to: self.userNameLabel!.rx.text).disposed(by: bag)
    }
}
