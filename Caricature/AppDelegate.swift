//
//  AppDelegate.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/10/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.initWindow()
		self.initKeyboard()
		return true
	}
	
	func initWindow() -> Void {
		self.window = UIWindow.init(frame: UIScreen.main.bounds)
		self.window?.backgroundColor = UIColor.white;
		let tabBarController = HZTabBarController.init()
		self.window?.rootViewController = tabBarController
		self.window?.makeKeyAndVisible()
	}
	
	
	func initKeyboard() -> Void {
		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
		//控制点击背景是否收起键盘
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true
		//IQKeyboardManager.shared.disabledToolbarClasses = [HZHomeDetailViewController.Type]()
	}
}

