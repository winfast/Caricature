//
//  CTRankingViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/10/27.
//

import UIKit
import JXSegmentedView

class CTRankingViewController: HZBaseViewController {
	
	var tableView: UITableView?
	
	fileprivate let viewModel : CTRankingViewModel = CTRankingViewModel.init()
	
	let disposeBag: DisposeBag = DisposeBag.init()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.viewsLayout()
		self.dataRequest()
    }
	
	func viewsLayout() -> Void {
		// Do any additional setup after loading the view.
		self.tableView = UITableView.init(frame: .zero, style: .grouped)
		self.tableView?.backgroundColor = CTBackgroundColor()
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		self.tableView?.separatorStyle = .none
		self.tableView?.estimatedRowHeight = 202
		self.tableView?.rowHeight = UITableView.automaticDimension
		self.tableView?.register(CTRankingTableViewCell.classForCoder(), forCellReuseIdentifier: "CTRankingTableViewCell")
		self.view.addSubview(self.tableView!)
		self.tableView!.snp.makeConstraints({ (make) in
			make.edges.equalTo(0)
		})
	}
	
	func dataRequest() -> Void {
		self.viewModel.rankList(param: [:]).subscribe(onNext: { [weak self] _ in
			guard let weakself = self else {
				return
			}
			
			weakself.tableView?.reloadData()
		}).disposed(by: disposeBag)
	}
}
 
extension CTRankingViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.viewModel.dataSource?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CTRankingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CTRankingTableViewCell") as! CTRankingTableViewCell
		cell.cellViewModel = self.viewModel.dataSource![indexPath.section]
        cell.selectionStyle = .none
		return cell
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView.init()
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0.000001
	}
}

extension CTRankingViewController: JXSegmentedListContainerViewListDelegate {
	func listView() -> UIView {
		return view
	}
}
