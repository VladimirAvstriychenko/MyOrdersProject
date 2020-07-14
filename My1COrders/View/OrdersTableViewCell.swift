//
//  OrdersTableViewCell.swift
//  My1COrders
//
//  Created by Владимир on 12.04.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var counteragentLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
