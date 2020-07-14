//
//  ItemViewController.swift
//  My1COrders
//
//  Created by Владимир on 12.06.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import UIKit

class ItemViewController:UIViewController {
    
    var item:Item?
    var stringNumber:Int = 0
    
    @IBOutlet weak var stringNumberLabel: UILabel!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var characteristikTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var availableTextField: UITextField!
    @IBOutlet weak var unitNameTextField: UITextField!
    @IBOutlet weak var priceTypeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ndsSumTextField: UITextField!
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var loadingDateTextField: UITextField!
    
    override func viewDidLoad() {
        fetchFields()
    }
    
    func fetchFields(){
        stringNumberLabel.text = "Строка № /(stringNumber)"
        itemNameTextField.text = item?.itemName
        characteristikTextField.text = item?.characteristikName
        quantityTextField.text = item?.quantity
        //availableTextField.text = item?.available
        unitNameTextField.text = item?.unitName
        priceTypeTextField.text = item?.priceType
        priceTextField.text = item?.price
        //ndsSumTextField.text = item?.ndsSum
        sumTextField.text = item?.sum
        loadingDateTextField.text = item?.loadingDate
    }
    
}
