//
//  CTCateListViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit
import ZLCollectionViewFlowLayout

class CTCateListViewController: HZBaseViewController {
	
	fileprivate var collectionView : UICollectionView?
	fileprivate var viewModel : CTCateListViewModel = CTCateListViewModel.init()
	
	let bag: DisposeBag = DisposeBag.init()
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.hbd_barStyle = .blackOpaque
		self.hbd_barShadowHidden = true
		self.hbd_barImage = UIImage.init(named: "nav_bg")
		
		self.viewsLayout()
		self.dataRequest()
    }
	
	func viewsLayout() -> Void {
		
		let searchBtn = UIButton.init(type: .custom)
		searchBtn.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 30)
		searchBtn.backgroundColor =  UIColor.black.withAlphaComponent(0.1)
		searchBtn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
		searchBtn.setTitleColor(.white, for: .normal)
		searchBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
		searchBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
		searchBtn.layer.cornerRadius = 15
		searchBtn.layer.masksToBounds = true
		searchBtn.rx.tap.subscribe(onNext: { [weak self] in
			guard let weakself = self else {
				return
			}
			let vc = CTSearchViewController.init()
			weakself.navigationController?.pushViewController(vc, animated: true)
		}).disposed(by: bag)
		self.navigationItem.titleView = searchBtn
		
		let flowerLayout = ZLCollectionViewVerticalLayout.init()
		flowerLayout.layoutType = ZLLayoutType.init(rawValue: 3)
		//flowerLayout.itemSize = CGSize.init(width: (HZSCreenWidth() - 5.0) * 0.5, height: 90.0)
		flowerLayout.minimumLineSpacing = 10
		flowerLayout.delegate = self
		flowerLayout.minimumInteritemSpacing = 10
		self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowerLayout)
		self.collectionView?.delegate = self
		self.collectionView?.dataSource = self
		self.collectionView?.backgroundColor = CTBackgroundColor()
		self.collectionView?.alwaysBounceVertical = true
		//self.collectionView?.contentInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 10, right: 10)
		self.collectionView?.register(CTCateListCollectionViewCell.self, forCellWithReuseIdentifier: "CTCateListCollectionViewCell")
		self.view.addSubview(self.collectionView!)
		self.collectionView?.snp.makeConstraints({ (make) in
			make.edges.equalTo(0)
		})
	}
	
	func dataRequest() -> Void {
		self.viewModel.cateList(param: [:]).subscribe(onNext: { [weak self] _ in
			guard let weakself = self else {
				return
			}
			
			weakself.collectionView?.reloadData()
		}).disposed(by: bag)
	}
}

extension CTCateListViewController: UICollectionViewDelegate, UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.dataSource?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CTCateListCollectionViewCell", for: indexPath) as! CTCateListCollectionViewCell
		cell.backgroundColor = .clear
		cell.cellViewModel = self.viewModel.dataSource![indexPath.item]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize.init(width: 1, height: HZAdpatedWidth(x: 130))
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.init(top: 20, left: 10, bottom: 10, right: 10)
	}
	
//	//设置header高度
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//		return CGSize.init(width: HZSCreenWidth(), height: 44)
//	}
//
//	//设置Footer高度
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//		return CGSize.init(width: HZSCreenWidth(), height: 10)
//	}
//
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, backColorForSection section: Int) -> UIColor {
//		return.white
//	}
//
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, registerBackView section: Int) -> String {
//		return NSStringFromClass(CTRecommendCollectionReusableView.self) as String
//	}
//
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, attachToTop section: Int) -> Bool {
//		return false
//	}

	//类布局, 每行两列
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, columnCountOfSection section: Int) -> Int {
		return 3
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cellViewModel = self.viewModel.dataSource![indexPath.item]
		let vc = CTComicListViewController.init(argCon: cellViewModel.argCon, argName: cellViewModel.argName ?? "", argValue: cellViewModel.argValue)
		//vc.nav
		vc.navigationItem.title = cellViewModel.sortName
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
