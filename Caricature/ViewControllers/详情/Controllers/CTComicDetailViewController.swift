//
//  CTComicDetailViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/10.
//

import UIKit
import JXSegmentedView
import JXPagingView

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class CTComicDetailViewController: HZBaseViewController {
	
	lazy var pagingView: JXPagingView = {
		let pageingView = JXPagingView.init(delegate: self)
		return pageingView
	}()
	
	lazy var userHeaerView: CTComicDetailHeaderView = {
		let userHeaerView = CTComicDetailHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: HZSCreenWidth(), height: 214))
		return userHeaerView
	}()
	
	lazy var segmentedView: JXSegmentedView = {
		let segmentedView = JXSegmentedView.init(frame: CGRect.init(x: 0, y: 0, width: HZSCreenWidth(), height: 40))
		return segmentedView
	}()
	
	var titles = ["详情", "目录", "评论"]
	let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
	fileprivate let viewModel : CTComicDetailViewModel = CTComicDetailViewModel.init()
	fileprivate let bag : DisposeBag = DisposeBag.init()
	
	private var comicId : Int = 0
	private var comicDetailView : CTComicDetailView?
	private var comicCatalogView : CTComicCatalogView?
	
	convenience init(comicid: Int) {
		self.init()
		self.comicId = comicid
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.view.backgroundColor = CTBackgroundColor()
		
		self.hbd_barStyle = .blackOpaque
		self.hbd_barShadowHidden = true
		self.hbd_barImage = UIImage.init(named: "nav_bg")
		self.hbd_barAlpha = 0.0
		
		self.viewsLayout()
		self.dataRequset()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
	
	func viewsLayout() -> Void {
		
		self.comicDetailView = CTComicDetailView.init(currViewMode: self.viewModel)
		self.comicCatalogView = CTComicCatalogView.init(currViewMode: self.viewModel)
		
		dataSource.titles = titles
		dataSource.titleSelectedColor = UIColor(red: 127/255, green: 221/255, blue: 146/255, alpha: 1)
		dataSource.titleNormalColor = UIColor.black
		dataSource.isTitleColorGradientEnabled = true
		dataSource.titleNormalFont = HZFont(fontSize: 15)
		dataSource.titleSelectedFont = HZFont(fontSize: 15)
		dataSource.isTitleZoomEnabled = false
		dataSource.itemSpacing = 0
		dataSource.itemWidth = HZSCreenWidth()/3.0
		
		segmentedView.backgroundColor = UIColor.white
		segmentedView.delegate = self
		segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
		segmentedView.dataSource = dataSource
		self.segmentedView.contentEdgeInsetLeft = 0
		self.segmentedView.contentEdgeInsetRight = 0

		let lineView = JXSegmentedIndicatorLineView()
		lineView.indicatorColor = UIColor(red: 127/255, green: 221/255, blue: 146/255, alpha: 1)
		lineView.indicatorWidth = 40
		lineView.indicatorHeight = 2
		lineView.indicatorCornerRadius = 0
		segmentedView.indicators = [lineView]

		let lineWidth = 1/UIScreen.main.scale
		let bottomLineView = UIView()
		bottomLineView.backgroundColor = UIColor.lightGray
		bottomLineView.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
		bottomLineView.autoresizingMask = .flexibleWidth
		segmentedView.addSubview(bottomLineView)
		pagingView.mainTableView.gestureDelegate = self
		self.view.addSubview(pagingView)
		pagingView.snp.makeConstraints { (make) in
			make.edges.equalTo(0);
		}
		
		segmentedView.listContainer = pagingView.listContainerView

		//扣边返回处理，下面的代码要加上
		pagingView.pinSectionHeaderVerticalOffset = Int.init(HZNavBarHeight())
		pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
		pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
	}
	
	func dataRequset() -> Void {
		let group = DispatchGroup.init()
		let param = ["comicid" : self.comicId]
		
		group.enter()
		self.viewModel.comicDetail(param: param).subscribe(onNext: {(_) in
//			guard let weakself = self else {
//				return
//			}
			group.leave()
		}).disposed(by: bag)
		
		group.enter()
		self.viewModel.comicDetailRealtime(param: param).subscribe(onNext: {(_) in
			group.leave()
		}).disposed(by: bag)
		self.comicDetailView?.ct_prepareToShow()
		group.notify(queue: DispatchQueue.main) {
			self.comicDetailView?.ct_makeVisble()
			self.userHeaerView.detailViewModel = self.viewModel.comicDetaiInfoViewModel
			self.comicDetailView?.reloadData()
		}
	}
	
	func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
		let thresholdDistance: CGFloat = 100
		var percent = scrollView.contentOffset.y/thresholdDistance
		percent = max(0, min(1, percent))
		self.hbd_barAlpha = Float(percent)
		self.hbd_setNeedsUpdateNavigationBar()
		
		self.userHeaerView.scrollViewDidScroll(scrollView)
		if percent >= 1 {
			self.navigationItem.title = self.viewModel.comicDetaiInfoViewModel.name
		} else {
			self.navigationItem.title = ""
		}
	}
}


extension CTComicDetailViewController: JXPagingViewDelegate {

	func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
		return 214
	}

	func tableHeaderView(in pagingView: JXPagingView) -> UIView {
		return self.userHeaerView
	}

	func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
		return 40
	}

	func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
		return segmentedView
	}

	func numberOfLists(in pagingView: JXPagingView) -> Int {
		return titles.count
	}

	func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
//		let view = CTComicDetailView.init()
//		return view
		if 0 == index {
			return self.comicDetailView!
		} else if 1 == index {
			return self.comicCatalogView!
		}
		
		return self.comicDetailView!
	}
}

extension CTComicDetailViewController: JXSegmentedViewDelegate {
	func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
	}
}

extension CTComicDetailViewController: JXPagingMainTableViewGestureDelegate {
	func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		//禁止segmentedView左右滑动的时候，上下和左右都可以滚动
		if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
			return false
		}
		return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
	}
}
