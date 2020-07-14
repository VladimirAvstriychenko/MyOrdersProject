//
//  OrdersSelectButton.swift
//  My1COrders
//
//  Created by Владимир on 04.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import UIKit

class OrdersSelectButton:UIButton {
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    func initial(){
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 1
    }
}
