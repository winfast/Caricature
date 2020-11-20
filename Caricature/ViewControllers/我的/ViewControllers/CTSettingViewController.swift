//
//  CTSettingViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit

class CTSettingViewController: HZBaseViewController {
	
	lazy fileprivate var tableView : UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .grouped)
		
		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
