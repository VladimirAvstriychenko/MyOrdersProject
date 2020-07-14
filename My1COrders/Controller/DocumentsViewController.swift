//
//  DocumentsViewController.swift
//  My1COrders
//
//  Created by Владимир on 11.04.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import Foundation

import UIKit

class DocumentsViewController: UIViewController {
    //@IBOutlet weak var ordersButton: UIButton!
    
    @IBOutlet weak var ordersSelectorView: UIView!
    @IBOutlet weak var ordersButtonImage: UIImageView!
    @IBOutlet var ordersLongPressGC: UILongPressGestureRecognizer!
    override func viewDidLoad() {
//        let image = UIImage(systemName: "cart")!.withAlignmentRectInsets(UIEdgeInsets(top: 20, left:-20, bottom:0, right: 0))
//        ordersButton.frame = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
//        ordersButton.setBackgroundImage(image, for: UIControl.State())
        ordersSelectorView.layer.cornerRadius = 5
        ordersLongPressGC.minimumPressDuration = 0.01
    }
//    @IBAction func ordersTapped(_ sender: UILongPressGestureRecognizer) {
//        if sender.state == .ended {
//            ordersButtonImage.image = UIImage(systemName: "cart")
//        } else {
//            ordersButtonImage.image = UIImage(systemName: "cart.fill")
//        }
//    }
    @IBAction func ordersTapped(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            
            ordersButtonImage.image = UIImage(systemName: "cart")
            
//            let backItem = UIBarButtonItem()
//            backItem.title = "Назад"
//            navigationItem.backBarButtonItem = backItem
            
//            navigationController!.renameBackButton1("Назад")// renameBackButton("Назад")
            
            performSegue(withIdentifier: "showOrdersViewController", sender: self)
        } else {
            ordersButtonImage.image = UIImage(systemName: "cart.fill")
        }
    }
    
}
