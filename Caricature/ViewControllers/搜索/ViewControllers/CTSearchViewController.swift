//
//  CTSearchViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/6.
//

import UIKit

class CTSearchViewController: HZBaseViewController {
	
	enum CTSearchTableViewTag : Int {
		case searchList = 0
		case searchKeyWork = 1
		case searchDefault = 2
	}
	
	var viewwModel : CTSearchViewModel = CTSearchViewModel.init()
	fileprivate let bag : DisposeBag = DisposeBag.init()
	//显示搜索列表
	lazy fileprivate var searchListTableView : UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .plain)
		tableView.tag = CTSearchTableViewTag.searchList.rawValue
		tableView.estimatedRowHeight = 100
		tableView.backgroundColor = .clear
		tableView.rowHeight = UITableView.automaticDimension
		tableView.tableFooterView = UIView.init()
		tableView.register(CTSearchResultTableViewCell.self, forCellReuseIdentifier: "CTSearchResultTableViewCell")
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}()
	
	//显示搜索关键字的列表
	lazy fileprivate var searchKeyWordListTableView : UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .plain)
		tableView.tag = CTSearchTableViewTag.searchKeyWork.rawValue
		tableView.estimatedRowHeight = 44
		tableView.backgroundColor = .clear
		tableView.rowHeight = UITableView.automaticDimension
		//tableView.separatorColor = .lightGray
		tableView.tableFooterView = UIView.init()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		return tableView
	}()
	
	//显示搜索页面的默认显示
	lazy fileprivate var searchDefaultTableView: UITableView = {
		let tableView = UITableView.init(frame: .zero, style: .grouped)
		tableView.tag = CTSearchTableViewTag.searchDefault.rawValue
		tableView.register(CTSearchHeaderTableView.self, forHeaderFooterViewReuseIdentifier: "CTSearchHeaderTableView")
		tableView.estimatedRowHeight = 100
		tableView.backgroundColor = .clear
		tableView.rowHeight = UITableView.automaticDimension
		tableView.separatorStyle = .none
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(CTAllSearchTableViewCell.self, forCellReuseIdentifier: "CTAllSearchTableViewCell")
		return tableView
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.hbd_barStyle = .blackOpaque
		self.hbd_barShadowHidden = true
		self.hbd_barImage = UIImage.init(named: "nav_bg")
		self.navigationViewsLayout()
		
		self.viewsLayout()
		self.dataRequest()
    }
	
	func navigationViewsLayout() -> Void {
		self.hbd_tintColor = .white
		let rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(clickRightBtn(sender:)))
		rightBarButtonItem.setTitlePositionAdjustment(UIOffset.init(horizontal: 12, vertical: 0), for: .default)
		self.navigationItem.rightBarButtonItem = rightBarButtonItem
		self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIView.init())
		
		let textField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: HZSCreenWidth() - 10 - 5, height: 30))
		textField.backgroundColor = .white
		textField.layer.cornerRadius = 15
		textField.layer.masksToBounds = true
		textField.tintColor = UIColorWithHexAndAlpha(rgbValue: 0x000000, alpha: 0.6)
		textField.leftViewMode = .always
		textField.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 18, height:30))
		textField.rightViewMode = .always
		textField.returnKeyType = .search
		textField.delegate = self;
		textField.font = HZFont(fontSize: 14)
		textField.textColor = UIColor.gray
		textField.placeholder = "输入漫画名称/作者"
		textField.rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 18, height:30))
		textField.rx.text.orEmpty.throttle(0.3, latest: true, scheduler: MainScheduler.instance).distinctUntilChanged().subscribe { [weak self] (value) in
			//网络请求
			guard let weakself = self else {
				return
			}
			
			let strValue: String = value.element ?? ""
			weakself.viewwModel.searchRelative(param: ["inputText":strValue]).subscribe { [weak self] (_) in
				guard let weakself = self else {
					return
				}
				
				if strValue.lengthOfBytes(using: .utf8) == 0 {
					weakself.searchDefaultTableView.isHidden = false
					weakself.searchDefaultTableView.reloadData()
					weakself.searchListTableView.isHidden = true
					weakself.searchKeyWordListTableView.isHidden = true
					weakself.searchKeyWordListTableView.reloadData()
				} else {
					weakself.searchDefaultTableView.isHidden = true
					weakself.searchListTableView.isHidden = true
					weakself.searchKeyWordListTableView.isHidden = false
					weakself.searchKeyWordListTableView.reloadData()
				}
			}
		}.disposed(by: bag)
		self.navigationItem.titleView = textField
	}
	
	func dataRequest() -> Void {
		self.viewwModel.searchHot(param: [:]).subscribe(onNext: { [weak self] _ in
			guard let weakself = self else {
				return
			}
			
			weakself.searchDefaultTableView.reloadData()
		}).disposed(by: bag)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let textField = self.navigationItem.titleView as! UITextField
		textField.becomeFirstResponder()
	}
	
	@objc private func clickRightBtn(sender: UIBarButtonItem) -> Void {
		self.navigationController?.popViewController(animated: true)
	}
	
	func viewsLayout() -> Void {
		self.view.backgroundColor = CTBackgroundColor()
		self.searchListTableView.isHidden = true
		self.view.addSubview(self.searchListTableView)
		self.view.addSubview(self.searchDefaultTableView)
		self.searchKeyWordListTableView.isHidden = true
		self.view.addSubview(self.searchKeyWordListTableView);
		
		self.searchDefaultTableView.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
		self.searchListTableView.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
		self.searchKeyWordListTableView.snp.makeConstraints { (make) in
			make.edges.equalTo(0)
		}
	}
	
	func searchListDataRequest(name : String) -> Void {
		let param = ["argCon" : 0, "q" : name] as [String:Any]
		self.viewwModel.searchList(param: param).subscribe(onNext: { [weak self] (_) in
			guard let weakself = self else  {
				return
			}
			
			weakself.searchDefaultTableView.isHidden = true
			weakself.searchKeyWordListTableView.isHidden = true
			weakself.searchListTableView.isHidden = false
			weakself.searchListTableView.reloadData()
		
		}).disposed(by: bag)
	}
}

extension CTSearchViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue {
			if section == 1 {
				return 1
			}
			return 1
		} else if tableView.tag == CTSearchTableViewTag.searchKeyWork.rawValue {
			return self.viewwModel.searchRelativeDataSource?.count ?? 0
		} else {
			return self.viewwModel.searchResultDataSource?.count ?? 0
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue {
			return 2
		} else {
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue{
			if indexPath.section == 1 {
				let cell = tableView.dequeueReusableCell(withIdentifier: "CTAllSearchTableViewCell") as! CTAllSearchTableViewCell
				cell.backgroundColor = .clear
				cell.cellViewModel = self.viewwModel
				cell.selectedSearchKeyWord = { [weak self] (selectedIndex) -> Void in
					guard let weakself = self else {
						return
					}
					
				}
				return cell
			} else {
				return UITableViewCell.init()
			}
		} else if tableView.tag == CTSearchTableViewTag.searchKeyWork.rawValue {
			let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
			cell.textLabel?.text = self.viewwModel.searchRelativeDataSource![indexPath.row]
			cell.textLabel?.font = HZFont(fontSize: 13)
			cell.textLabel?.textColor = .darkGray
			cell.separatorInset = .zero
			cell.selectionStyle = .none
			return cell
		} else {
			let cell : CTSearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CTSearchResultTableViewCell") as! CTSearchResultTableViewCell
			cell.cellViewModel = self.viewwModel.searchResultDataSource![indexPath.row]
			cell.separatorInset = .zero
			cell.selectionStyle = .none
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue {
			let view = UIView.init()
			view.backgroundColor = .clear
			return view
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue {
			return 10
		}
		return 0.0001
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue {
			let view : CTSearchHeaderTableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CTSearchHeaderTableView") as! CTSearchHeaderTableView
			if section == 0 {
				view.titleLabel?.text = "看看你都搜过什么"
			} else {
				view.titleLabel?.text = "大家都在搜"
			}
			return view
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue {
			return 44;
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.tag == CTSearchTableViewTag.searchDefault.rawValue {
			
		} else if tableView.tag == CTSearchTableViewTag.searchKeyWork.rawValue {
			//点击搜索结果显示列表
			self.searchListDataRequest(name: self.viewwModel.searchRelativeDataSource![indexPath.row])
		} else {
			
		}
	}
}

extension CTSearchViewController : UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true)
		return true
	}
}
