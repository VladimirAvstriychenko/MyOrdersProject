//
//  ItemsTableViewCell.swift
//  My1COrders
//
//  Created by Владимир on 10.06.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import Foundation

import UIKit

class ItemsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var pricetTextField: UITextField!
    @IBOutlet weak var characteristikNameTextField: UITextField!
    
 

    @IBOutlet weak var quantityTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code test
        //statusView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
