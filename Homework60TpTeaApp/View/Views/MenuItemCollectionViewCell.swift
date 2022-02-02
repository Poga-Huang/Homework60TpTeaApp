//
//  MenuItemCollectionViewCell.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/28.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuItemImageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuItemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    static let width = floor(Double((UIScreen.main.bounds.width-120)/2))
    
    override func awakeFromNib() {
        imageWidthConstraint.constant = Self.width
        menuItemImageView.layer.cornerRadius = 10
    }
}
