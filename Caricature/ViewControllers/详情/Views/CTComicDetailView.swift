//
//  CTComicDetailView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/10.
//

import UIKit
import JXPagingView
import MJRefresh

class CTComicDetailView: UIView {
	
	let tableView : UITableView = UITableView.init(frame: .zero, style: .grouped)
	
	var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    weak var navigationController: UINavigationController?
	
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
		tableView.backgroundColor = CTBackgroundColor()
		tableView.tableFooterView = UIView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44
		tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
		tableView.register(CTWorkingDesTableViewCell.self, forCellReuseIdentifier: "CTWorkingDesTableViewCell")
		tableView.register(CTOtherWorkingTableViewCell.self, forCellReuseIdentifier: "CTOtherWorkingTableViewCell")
		tableView.register(CTTMonthTicketTableViewCell.self, forCellReuseIdentifier: "CTTMonthTicketTableViewCell")
		tableView.register(CTLikeComicTableViewCell.self, forCellReuseIdentifier: "CTLikeComicTableViewCell")
		self.addSubview(tableView)
		self.tableView.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
	}
	
	func reloadData() -> Void {
		self.tableView.reloadData()
	}
}

extension CTComicDetailView : UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch (indexPath.row, indexPath.section) {
		case (0, 0):
			let cell : CTWorkingDesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CTWorkingDesTableViewCell", for: indexPath) as! CTWorkingDesTableViewCell
			cell.detailViewModel = self.viewModel?.comicDetaiInfoViewModel
            cell.selectionStyle = .none
			return cell
		case (0, 1):
			let cell : CTOtherWorkingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CTOtherWorkingTableViewCell", for: indexPath) as! CTOtherWorkingTableViewCell
			cell.viewModel = self.viewModel
            cell.selectionStyle = .none
			cell.accessoryType = .disclosureIndicator
			return cell
		case (0, 2):
			let cell : CTTMonthTicketTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CTTMonthTicketTableViewCell", for: indexPath) as! CTTMonthTicketTableViewCell
			cell.detailViewModel = self.viewModel?.comicDetaiInfoViewModel
            cell.selectionStyle = .none
			return cell
		case (0, 3):
			let cell : CTLikeComicTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CTLikeComicTableViewCell", for: indexPath) as! CTLikeComicTableViewCell
			cell.detailViewModel = self.viewModel
            cell.selectionStyle = .none
            cell.selectedGuessLikeComic = { [weak self] (_ indexPath: IndexPath) -> Void in
                guard let weakself = self else {
                    return
                }
                
                let cellViewModel = weakself.viewModel?.guessLikeComicDataSource?[indexPath.item]
                let comicId = cellViewModel?.comic_id ?? "0"
                let vc = CTComicDetailViewController.init(comicid: Int.init(comicId) ?? 0)
                weakself.navigationController?.pushViewController(vc, animated: true)
            }
			return cell
		default:
			return UITableViewCell.init()
		}
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            if self.viewModel?.comicOtherWorkingDataSource?.count ?? 0 > 0 {
                let vc:CTMyComicListViewController! = CTMyComicListViewController.init(dataSource: self.viewModel!.comicOtherWorkingDataSource!)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			return nil
		} else {
			let view = UIView.init()
			view.backgroundColor = .clear
			return view
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 0
		} else {
			return 10
		}
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.listViewDidScrollCallback?(scrollView)
	}
}

extension CTComicDetailView: JXPagingViewListViewDelegate {
	func listView() -> UIView {
		return self
	}

	func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
		self.listViewDidScrollCallback = callback
	}

	func listScrollView() -> UIScrollView {
		return self.tableView
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
