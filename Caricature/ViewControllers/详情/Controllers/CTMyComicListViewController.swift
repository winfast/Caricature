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
        flowerLayout.itemSize = CGSize.init(width: (HZSCreenWidth() - 40)/3.0, height: 155.0/111.0 * ((HZSCreenWidth() - 40)/3.0) + 45)
        flowerLayout.minimumLineSpacing = 5
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
        self.hbd_barShadowHidden = true
        self.hbd_barStyle = .blackOpaque
        self.hbd_barImage = UIImage.init(named: "nav_bg")
        self.navigationItem.title = "其他作品"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTMyComicListCollectionViewCell", for: indexPath) as! CTMyComicListCollectionViewCell
        cell.cellViewModel = self.dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
}
