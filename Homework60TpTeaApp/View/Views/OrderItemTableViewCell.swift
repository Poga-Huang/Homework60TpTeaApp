//
//  OrderItemTableViewCell.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/30.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {

    @IBOutlet weak var sequenceImageView: UIImageView!
    @IBOutlet weak var drinksCoverImageView: UIImageView!
    @IBOutlet weak var ordererNameLabel: UILabel!
    @IBOutlet weak var drinksNameLabel: UILabel!
    @IBOutlet weak var drinksContentLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
