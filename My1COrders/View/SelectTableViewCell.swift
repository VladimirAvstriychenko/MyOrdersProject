//
//  SelectTableViewCell.swift
//  PriceGet
//
//  Created by Владимир on 18.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit

class SelectTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
