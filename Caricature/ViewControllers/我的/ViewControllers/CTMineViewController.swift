//
//  CTMineViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit

class CTMineViewController: HZBaseViewController {
	
	lazy fileprivate var headerView : CTMineHeadView = {
		let view = CTMineHeadView.init(frame: CGRect.init(x: 0, y: 0, width: HZSCreenWidth(), height: 200))
		view.backgroundColor = .clear
		return view
	}()
	
	lazy var dataSource : [[[String:String]]] = {
		var array = [[["title":"我的VIP","imageName":"mine_vip","className":"HZBaseViewController"],
					  ["title":"充值妖气币","imageName":"mine_coin","className":"HZBaseViewController"]],
					 [["title":"消费记录","imageName":"mine_accout","className":"HZBaseViewController"],
					  ["title":"我的订阅","imageName":"mine_subscript","className":"HZBaseViewController"],
					  ["title":"我的封印图","imageName":"mine_seal","className":"HZBaseViewController"]],
					 [["title":"我的消息/优惠券","imageName":"mine_message","className":"HZBaseViewController"],
					  ["title":"妖果商城","imageName":"mine_cashew","className":"HZBaseViewController"],
					  ["title":"在线阅读流量","imageName":"mine_freed","className":"HZBaseViewController"]],
					 [["title":"我的VIP","imageName":"mine_feedBack","className":"HZBaseViewController"],
					  ["title":"我要反馈","imageName":"mine_mail","className":"HZBaseViewController"],
					  ["title":"给我们评分","imageName":"mine_judge","className":"HZBaseViewController"],
					  ["title":"成为作者","imageName":"mine_author","className":"HZBaseViewController"],
					  ["title":"设置","imageName":"mine_setting","className":"HZSettingViewController"]]]
		return array
	}()
	 
	lazy fileprivate var tableView : UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .grouped)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorColor = .lightGray
		tableView.rowHeight = 44
		tableView.backgroundColor = CTBackgroundColor()
		tableView.tableHeaderView = self.headerView
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		return tableView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hbd_barStyle = .blackOpaque
		self.hbd_barImage = UIImage.init(named: "nav_bg")
		self.hbd_barShadowHidden = true
		self.hbd_barAlpha = 0.0
		self.hbd_setNeedsUpdateNavigationBar()
		
		if #available(iOS 11.0, *) {
			self.tableView.contentInsetAdjustmentBehavior = .never
		} else {
			self.automaticallyAdjustsScrollViewInsets = false
		}
		self.view.addSubview(self.tableView)
		self.tableView.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
	}
}

extension CTMineViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource[section].count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.dataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
		cell.textLabel?.text = self.dataSource[indexPath.section][indexPath.row]["title"]
		cell.imageView?.image = UIImage.init(named: self.dataSource[indexPath.section][indexPath.row]["imageName"]!)
		cell.accessoryType = .disclosureIndicator
		cell.selectionStyle = .none
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView.init()
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView.init()
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0.00001
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.headerView.scrollViewDidScroll(scrollView)
		let offset : CGPoint = scrollView.contentOffset
		if (offset.y >= 200 - HZNavBarHeight()) {    // iOS13快速下拉，图片在屏幕顶部抖动
			self.hbd_barAlpha = 1
			self.navigationItem.title = "我的"
		} else {
			self.hbd_barAlpha = 0.0
			self.navigationItem.title = ""
		}
		self.hbd_setNeedsUpdateNavigationBar()
	}
}
