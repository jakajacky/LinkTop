//
//  ShareCell.swift
//  DynamicFlowLayoutDemo
//
//  Created by Ivan Hahanov on 8/21/17.
//  Copyright © 2017 Applikey. All rights reserved.
//

import UIKit

class ShareCell: UICollectionViewCell {

    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var tendencyLabel: UILabel!

	@IBOutlet weak var tendencyIcon: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
        categoryLabel.textColor = UIColor.gray;
		layer.cornerRadius = 14
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.3
		layer.shadowOffset = CGSize(width: 0, height: 5)
		layer.masksToBounds = false
	}
	
	
	
	private func twoDigitsFormatted(_ val: Double) -> String {
		return String(format: "%.0.2f", val)
	}
}
