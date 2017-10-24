//
//  ECGCell.swift
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/24.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

import UIKit

class ECGCell: UICollectionViewCell {

    var maxL:UILabel = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }

}
