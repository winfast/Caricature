//
//  CTComicCatalogView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/10.
//

import UIKit
import JXPagingView
import MJRefresh

class CTComicCatalogView: UIView {
	lazy var collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout.init()
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumLineSpacing = 10
		flowLayout.minimumInteritemSpacing = 10
		flowLayout.itemSize = CGSize.init(width: (HZSCreenWidth() - 30) * 0.5, height: 40)
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
		cv.dataSource = self
		cv.delegate = self
		cv.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
		cv.backgroundColor = CTBackgroundColor()
		cv.register(CTComicCotalogCollectionViewCell.self, forCellWithReuseIdentifier: "CTComicCotalogCollectionViewCell")
		cv.register(CTComicCotalogFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CTComicCotalogFooterCollectionReusableView")
		return cv
	}()
	
	
	var collectionViewDidScrollCallback: ((UIScrollView) -> ())?
	
	fileprivate var viewModel : CTComicDetailViewModel?

	convenience init(currViewMode: CTComicDetailViewModel) {
		self.init(frame: .zero)
		self.viewModel = currViewMode
		self.viewsLayout()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func viewsLayout() -> Void {
		self.addSubview(collectionView)
		self.collectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
	}
	
	func reloadData() -> Void {
		self.collectionView.reloadData()
	}
	
}

extension CTComicCatalogView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel?.comicChapterDataSource?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTComicCotalogCollectionViewCell", for: indexPath) as! CTComicCotalogCollectionViewCell
		cell.cellViewModel = self.viewModel?.comicChapterDataSource?[indexPath.item]
		return cell
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.collectionViewDidScrollCallback?(scrollView)
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CTComicCotalogFooterCollectionReusableView", for: indexPath) as! CTComicCotalogFooterCollectionReusableView
			let name = self.viewModel?.comicChapterDataSource?.last?.name
			view.contentLabel.text = String.init(format: "目录 %@ 更新 %@", self.viewModel?.comicDetaiInfoViewModel.lastUpdateTime ?? "", name ?? "")
			return view
		}
		return UICollectionReusableView.init()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize.init(width: HZSCreenWidth(), height: 30)
	}
}

extension CTComicCatalogView: JXPagingViewListViewDelegate {
	func listView() -> UIView {
		return self
	}

	func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
		self.collectionViewDidScrollCallback = callback
	}

	func listScrollView() -> UIScrollView {
		return self.collectionView
	}

	func listWillAppear() {
		print("listWillAppear")
	}

	func listDidAppear() {
		print("listDidAppear")
	}

	func listWillDisappear() {
		print("listWillDisappear")
	}

	func listDidDisappear() {
		print("listDidDisappear")
	}
}
