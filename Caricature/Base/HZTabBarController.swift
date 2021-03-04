//
//  HZTabBarController.swift
//  HZTT
//
//  Created by QinChuancheng on 2020/8/17.
//  Copyright © 2020 Galanz. All rights reserved.
//

import UIKit

class HZTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.view.backgroundColor = .white;
		self.tabBar.isTranslucent = false;
		
		self.initTabar()
    }
	
	func initTabar() -> Void {
		self.delegate = self;
		
		if #available(iOS 13.0, *) {
			let appearance = self.tabBar.standardAppearance
			appearance.backgroundImage = HZImageWithColor(color: UIColorWith24Hex(rgbValue: 0xFFFFFF))
			appearance.shadowImage = HZImageWithColor(color: UIColorWith24Hex(rgbValue: 0xEEEEEE))
			appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black];
			//appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSAttributedString.Key.foregroundColor : UIColorWith24Hex(rgbValue: 0xFF3F00)};
			//appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, -2);
			self.tabBar.standardAppearance = appearance;
			
		} else {
			self.tabBar.backgroundImage = HZImageWithColor(color: UIColorWith24Hex(rgbValue: 0xFFFFFF))
			self.tabBar.shadowImage = HZImageWithColor(color: UIColorWith24Hex(rgbValue: 0xEEEEEE))
			self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
		}
		
		let itemTitlesArray: Array<String> = [
			"",
			"",
			"",
			""];
		let icon_normalsArray: Array<String> =  [
			"tab_home",
			"tab_class",
			"tab_book",
			"tab_mine"]

		let icon_selectedsArray: Array<String> = [
			"tab_home_S",
			"tab_class_S",
			"tab_book_S",
			"tab_mine_S" ]

		let vcNamesArray :Array<String> = [
			"CTHomeViewController",
			"CTCateListViewController",
			"HZBaseViewController",
			"CTMineViewController",
		]

		var viewControllers: Array<UIViewController> = Array.init()
		for index in 0..<vcNamesArray.count {
			let appName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
			let cls = NSClassFromString(appName + "." + vcNamesArray[index]) as! UIViewController.Type
			let vc:UIViewController! = cls.init();
			let barItem = UITabBarItem(title: itemTitlesArray[index], image: UIImage.init(named: icon_normalsArray[index])?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: icon_selectedsArray[index])?.withRenderingMode(.alwaysOriginal))
			vc.tabBarItem = barItem
			vc.title = itemTitlesArray[index]
			barItem.tag = index
            barItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
			barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected)
			let navigation = HZNavigationController.init(rootViewController: vc);
			viewControllers.append(navigation)

		}
		self.viewControllers = viewControllers;
	}
}

extension HZTabBarController :UITabBarControllerDelegate {
//	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//		let tag = viewController.tabBarItem.tag
//		if 2 == tag {
//			let vc = HZReleaseNewsViewController.init()
//			let nav = HZNavigationController.init(rootViewController: vc)
//			nav.modalPresentationStyle = .fullScreen
//			self.present(nav, animated: true, completion: nil)
//			return false
//		} else {
//			return true
//		}
		
//	}
}
