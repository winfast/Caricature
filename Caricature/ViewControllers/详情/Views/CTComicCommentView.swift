//
//  CTComicCommentView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/10.
//

import UIKit
import JXPagingView
import MJRefresh


class CTComicCommentView: UIView {
    
    let tableView : UITableView = UITableView.init(frame: .zero, style: .plain)
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
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
        tableView.register(CTCommentTableViewCell.self, forCellReuseIdentifier: "CTCommentTableViewCell")
        self.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    open func reloadData() -> Void {
        self.tableView.reloadData()
    }
}

extension CTComicCommentView : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel!.comicCommentDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CTCommentTableViewCell") as! CTCommentTableViewCell
        cell.cellViewModel = self.viewModel?.comicCommentDataSource![indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return nil
//        } else {
//            let view = UIView.init()
//            view.backgroundColor = .clear
//            return view
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 0 : 15
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

extension CTComicCommentView: JXPagingViewListViewDelegate {
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
