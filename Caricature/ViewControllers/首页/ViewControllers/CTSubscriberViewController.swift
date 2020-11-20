//
//  CTSubscriberViewController.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/10/27.
//

import UIKit
import JXSegmentedView

class CTSubscriberViewController: HZBaseViewController {
	
	var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CTSubscriberViewController: JXSegmentedListContainerViewListDelegate {
	func listView() -> UIView {
		return view
	}
}
