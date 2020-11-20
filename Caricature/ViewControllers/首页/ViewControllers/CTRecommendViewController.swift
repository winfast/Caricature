//
//  CTCTRecommendViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/10/27.
//

import UIKit
import JXSegmentedView
import RxSwift
import ZLCollectionViewFlowLayout

class CTRecommendViewController: HZBaseViewController {
	
	//懒加载
//	lazy private var viewModel: CTRecommentViewModel = {
//		return CTRecommentViewModel.init()
//	}()
	
	private let viewModel: CTRecommentViewModel = CTRecommentViewModel.init()
	
	var collectionView: UICollectionView?
	
	let disposeBag: DisposeBag = DisposeBag.init()
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.viewsLayout()
		
		let param : [String : Any] = ["sexType" : 0] as [String : Any]
		self.viewModel.boutiqueList(param: param).subscribe(onNext: { [weak self] _ in
			guard let weakself = self else {
				return
			}
			weakself.collectionView?.reloadData()
		}).disposed(by: disposeBag)
    }
	
	func viewsLayout() -> Void {
		let flowerLayout = ZLCollectionViewVerticalLayout.init()
		flowerLayout.layoutType = ZLLayoutType.init(rawValue: 3)
		//flowerLayout.itemSize = CGSize.init(width: (HZSCreenWidth() - 5.0) * 0.5, height: 90.0)
		flowerLayout.minimumLineSpacing = 10
		flowerLayout.delegate = self
		flowerLayout.minimumInteritemSpacing = 5
		let appName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String + ".CTRecommendCollectionReusableView"
		flowerLayout.registerDecorationView([appName])
		self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowerLayout)
		self.collectionView?.delegate = self
		self.collectionView?.dataSource = self
		self.collectionView?.backgroundColor = CTBackgroundColor()
		self.collectionView?.alwaysBounceVertical = true
		self.collectionView?.contentInset = UIEdgeInsets.init(top: 0.467 * HZSCreenWidth(), left: 0, bottom: 10, right: 0)
		self.collectionView?.register(CTRecommendCollectionViewCell.self, forCellWithReuseIdentifier: "CTRecommendCollectionViewCell")
		self.collectionView?.register(CTRecommendHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CTRecommendHeaderCollectionReusableView")
		self.collectionView?.register(CTRecommendFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CTRecommendFooterCollectionReusableView")
		self.view.addSubview(self.collectionView!)
		self.collectionView?.snp.makeConstraints({ (make) in
			make.edges.equalTo(0)
		})
		let desiredOffset = CGPoint(x: 0, y: -self.collectionView!.contentInset.top)
		self.collectionView?.setContentOffset(desiredOffset, animated: true)
		
//		DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
//			DispatchQueue.main.async {
//				self.collectionView?.reloadData()
//			}
//		}
	}
}

extension CTRecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.viewModel.dataSource?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionViewModel = self.viewModel.dataSource![section]
		var count = sectionViewModel.comics?.count ?? 0
		if count > 4 {
			count = 4
		}
		return count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CTRecommendCollectionViewCell", for: indexPath) as! CTRecommendCollectionViewCell
		cell.backgroundColor = .white
		let sectionViewModel = self.viewModel.dataSource![indexPath.section]
		cell.cellViewModel = sectionViewModel.comics![indexPath.item]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			let headerView : CTRecommendHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CTRecommendHeaderCollectionReusableView", for: indexPath) as! CTRecommendHeaderCollectionReusableView
			let sectionViewModel = self.viewModel.dataSource![indexPath.section]
			let count = sectionViewModel.comics?.count ?? 0
			headerView.backgroundColor = count > 0 ? .white : .clear
			headerView.sectionViewModel = self.viewModel.dataSource![indexPath.section]
			return headerView
		} else {
			let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CTRecommendFooterCollectionReusableView", for: indexPath)
			footerView.backgroundColor = .clear
			return footerView
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize.init(width: 1, height: 160)
	}
	
	//设置header高度
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize.init(width: HZSCreenWidth(), height: 44)
	}
	
	//设置Footer高度
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize.init(width: HZSCreenWidth(), height: 10)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, backColorForSection section: Int) -> UIColor {
		return.white
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, registerBackView section: Int) -> String {
		return NSStringFromClass(CTRecommendCollectionReusableView.self) as String
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, attachToTop section: Int) -> Bool {
		return false
	}

	//类布局, 每行两列
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, columnCountOfSection section: Int) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let sectionViewModel = self.viewModel.dataSource![indexPath.section]
		let cellViewModel = sectionViewModel.comics![indexPath.item]
		let vc = CTComicDetailViewController.init(comicid: cellViewModel.comicId)
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

extension CTRecommendViewController: JXSegmentedListContainerViewListDelegate {
	func listView() -> UIView {
		return view
	}
}
