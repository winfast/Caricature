//
//  CTRecommendCollectionReusableView.swift
//  Caricature
//
//  Created by QinChuancheng on 2020/11/5.
//

import UIKit

class CTRecommendCollectionReusableView: UICollectionReusableView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
