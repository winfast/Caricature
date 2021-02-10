//
//  CTMyComicListViewController.swift
//  Caricature
//
//  Created by Qincc on 2021/2/9.
//

import UIKit

class CTMyComicListViewController: HZBaseViewController {
    
    var dataSource: [CTOtherWorkCellViewModel] = []
    lazy var collectionView: UICollectionView = {
        let flowerLayout = UICollectionViewFlowLayout.init()
        flowerLayout.scrollDirection = .vertical
        flowerLayout.itemSize = CGSize.init(width: (HZSCreenWidth() - 40)/3.0, height: 155.0/111.0 * HZAdpatedWidth(x: 111.0 as CGFloat) + 45)
        flowerLayout.minimumLineSpacing = 10
        flowerLayout.minimumInteritemSpacing = 10
        let v: UICollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowerLayout)
        v.delegate = self;
        v.dataSource = self;
        v.backgroundColor = .clear
        v.register(CTMyComicListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CTMyComicListCollectionViewCell")
        v.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 20, right: 10)
        return v
    }()
    
    convenience init(dataSource: [CTOtherWorkCellViewModel]) {
        self.init()
        self.dataSource = dataSource
        self.viewsLayout()
    }
    
    func viewsLayout() -> Void {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
    }
}

extension CTMyComicListViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
}
