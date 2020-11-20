//
//  CTHomeViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/10/27.
//

import UIKit
import JXSegmentedView

class CTHomeViewController: HZBaseViewController {
	
	let segmentedView = JXSegmentedView()
	var segmentedDataSource: JXSegmentedTitleDataSource?
	lazy var listContainerView: JXSegmentedListContainerView! = {
		return JXSegmentedListContainerView(dataSource: self)
	}()
	
	let vcNamesArray: [String]! = ["CTRecommendViewController","CTVIPViewController","CTSubscriberViewController","CTRankingViewController"]
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.hbd_barStyle = .blackOpaque
		self.hbd_barShadowHidden = true
		self.hbd_barImage = UIImage.init(named: "nav_bg")
		self.viewLayout()
		
    }
	
	func viewLayout() -> Void {
		//self.navigationController?.navigationBar.shadowImage = HZImageWithColor(color: UIColorWith24Hex(rgbValue: 0xFF0000))
		self.navigationItem.title = ""
		let titles = ["推荐","VIP","订阅","排行"]
		
		self.segmentedDataSource = JXSegmentedTitleDataSource()
		self.segmentedDataSource?.isItemTransitionEnabled = true;
		self.segmentedDataSource?.titles = titles
		self.segmentedDataSource?.itemWidth = 60
		self.segmentedDataSource?.itemSpacing = 10
		self.segmentedDataSource?.isItemSpacingAverageEnabled = false
		self.segmentedDataSource?.titleNormalFont = HZFont(fontSize: 20)
		self.segmentedDataSource?.titleSelectedFont = HZFont(fontSize: 20)
		self.segmentedDataSource?.titleSelectedColor = UIColorWithHexAndAlpha(rgbValue: 0xFFFFFF, alpha: 1)
		self.segmentedDataSource?.titleNormalColor = UIColorWithHexAndAlpha(rgbValue: 0xFFFFFF, alpha: 0.5)
		self.segmentedView.dataSource = self.segmentedDataSource;
		self.segmentedView.delegate = self;
		self.segmentedView.contentEdgeInsetLeft = 0
		self.segmentedView.contentEdgeInsetRight = 0
//		let indicator: JXSegmentedIndicatorLineView = JXSegmentedIndicatorLineView()
//		indicator.indicatorWidth = 30
//		indicator.verticalOffset = 5
//		indicator.indicatorHeight = 2;
//		indicator.indicatorCornerRadius = 1;
//		indicator.indicatorColor = UIColorWith24Hex(rgbValue: 0xff4500)
//		self.segmentedView.indicators = [indicator]
		
		let bgView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0.0, width: 60 * 4 + 10 * 3, height: 44.0))
		self.segmentedView.frame = bgView.bounds
		bgView.addSubview(self.segmentedView)
		self.navigationItem.titleView = bgView

		self.segmentedView.listContainer = self.listContainerView
		self.view.addSubview(self.listContainerView)
		self.listContainerView.backgroundColor = UIColor.white
		self.listContainerView.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
	}
}

extension CTHomeViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
	func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
	   // navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
	}
	
	func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
		if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
			return titleDataSource.dataSource.count
		}
		return 0
	}
	
	func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
	
		if index == 0 {
			let vc = CTRecommendViewController.init()
			return vc
		} else if index == 1 {
			let vc = CTVIPViewController.init()
			return vc
		} else if index == 2 {
			let vc = CTSubscriberViewController.init()
			return vc
		} else  {
			let vc = CTRankingViewController.init()
			return vc
		}
	}
}
