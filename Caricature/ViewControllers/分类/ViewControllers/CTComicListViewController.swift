//
//  CTComicListViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/10.
//

import UIKit
import MJRefresh

class CTComicListViewController: HZBaseViewController {
	
	var argCon : Int?
	var argValue: Int?
	var argName: String?
	
	fileprivate var bag = DisposeBag.init()
	
	fileprivate var viewModel : CTComicListViewModel = CTComicListViewModel.init()
	
	lazy fileprivate var tableView: UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .plain)
		tableView.backgroundColor = .clear
		tableView.tableFooterView = UIView.init()
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 180
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(CTSearchResultTableViewCell.self, forCellReuseIdentifier: "CTSearchResultTableViewCell")
		tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
			guard let weakself = self else {
				return
			}
			weakself.tableView.mj_footer.isHidden = false
			weakself.tableView.mj_footer.state = .idle
			weakself.dataRequst(pageNumber: weakself.viewModel.page + 1)
		})
		
		tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
			guard let weakself = self else {
				return
			}
			weakself.dataRequst()
		})
		
		return tableView
	}()
	
	convenience init(argCon: Int = 0 ,argName: String, argValue: Int = 0) {
		self.init()
		self.argCon = argCon
		self.argName = argName
		self.argValue = argValue
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()

		self.hbd_barStyle = .blackOpaque
		self.hbd_barShadowHidden = true
		self.hbd_barImage = UIImage.init(named: "nav_bg")
		
		self.view.backgroundColor = CTBackgroundColor()
		self.view.addSubview(self.tableView)
		self.tableView.snp.makeConstraints { (make) in
			make.bottom.left.right.equalTo(0)
			make.top.equalTo(HZNavBarHeight())
		}
		
		self.dataRequst()
    }
	
	func dataRequst(pageNumber: Int = 1) -> Void {
		var param : [String: Any] = [:]
		param["argCon"] = argCon
		if argName != nil || argName!.count > 0 { param["argName"] = argName! }
		param["argValue"] = argValue
		param["page"] = pageNumber
		
		self.viewModel.comicList(param: param).subscribe(onNext: { [weak self] (_) in
			guard let weakself = self else {
				return
			}
			
			if weakself.tableView.mj_footer.isRefreshing() {
				weakself.tableView.mj_footer.endRefreshing()
			}
			
			if weakself.tableView.mj_header.isRefreshing() {
				weakself.tableView.mj_header.endRefreshing()
			}
			
			if weakself.viewModel.hasMore == false {
				weakself.tableView.mj_footer.isHidden = true
				weakself.tableView.mj_footer.state = .noMoreData
			} else {
				weakself.tableView.mj_footer.isHidden = false
				weakself.tableView.mj_footer.state = .idle
			}
			
			weakself.tableView.reloadData()
		}).disposed(by: bag)
	}
}

extension CTComicListViewController : UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.dataSource?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CTSearchResultTableViewCell") as! CTSearchResultTableViewCell
		cell.selectionStyle = .none
		cell.cellViewModel = self.viewModel.dataSource![indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}
