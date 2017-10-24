//
//  ShareCell.swift
//  DynamicFlowLayoutDemo
//
//  Created by Ivan Hahanov on 8/21/17.
//  Copyright © 2017 Applikey. All rights reserved.
//

import UIKit

class ShareCell: UICollectionViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		layer.cornerRadius = 4
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.3
		layer.shadowOffset = CGSize(width: 0, height: 5)
		layer.masksToBounds = false
	}
	
	
	
	private func twoDigitsFormatted(_ val: Double) -> String {
		return String(format: "%.0.2f", val)
	}
}
