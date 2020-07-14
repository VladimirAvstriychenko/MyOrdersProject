//
//  AdditionalOrderInfoViewController.swift
//  My1COrders
//
//  Created by Владимир on 18.05.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//


import UIKit
import CoreData

class AddtitionalOrderInfoViewController: UIViewController {
    
    var orderNumber = ""
    var orderDate = ""
    var orderInfo: OrderInfo?
//    var loginInfo = LoginInfo()
//    var ordersUrl = ""
    
    var index: Int = 0
    

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shipmentTypeTextField: UITextField!
    //@IBOutlet weak var shipmentAddressTextField: UITextField!
    @IBOutlet weak var shipmentAddressTextView: UITextView!
    @IBOutlet weak var shipmentPartnerTextField: UITextField!
    //@IBOutlet weak var shipmentPartnerAddressTextField: UITextField!
    @IBOutlet weak var shipmentPartnerAddressTextView: UITextView!
    
//    @IBOutlet weak var shipmentAddtitonalInfoTextField: UITextField!
    @IBOutlet weak var shipmentAdditionalInfoTextView: UITextView!
    
    //    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.contentSize = CGSize(width: 400, height: 780)
        //scrollView.contentSize = CGSize(width: 400, height: 780)
        scrollView.contentSize = contentView.frame.size
        scrollView.contentSize.width = 400
         scrollView.contentSize.height =  scrollView.contentSize.height - 200
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        
        fetchTextFields()
    }
    
//    func fetchOrders() {
//        //Getting current base address and access token
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//
//        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
//        do{
//            let logInfoArray = try context.fetch(fetchRequest)
//            if logInfoArray.count > 0 {
//                loginInfo = logInfoArray[0]
//            } else {return}
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//        var address = ""
//        var base64String = ""
//        address = loginInfo.baseUrl!
//        ordersUrl = address + "/hs/orders/GetOrderInfo"
//        base64String = loginInfo.token!
//
//        NetworkManager.fetchOrderInfo(url: ordersUrl, base64LoginString: base64String, orderDate: orderDate, orderNumber: orderNumber) {(orderInfo) in
//            self.orderInfo = orderInfo
//
//            DispatchQueue.main.async {
//                self.fetchTextFields()
//            }
//        }
//    }
    
    func fetchTextFields() {
//        managerTextField.text = self.orderInfo?.managerName
//        unitTextField.text = self.orderInfo?.unit
//        contactPersonTextField.text = self.orderInfo?.contactPersonName
//        taxtypeTextField.text = self.orderInfo?.taxType
        numberLabel.text = self.orderInfo?.orderNumber
        dateLabel.text = self.orderInfo?.orderDate
        shipmentTypeTextField.text = self.orderInfo?.shipmentType
        shipmentAddressTextView.text = self.orderInfo?.shipmentAddress
        shipmentPartnerTextField.text = self.orderInfo?.shipmentPartnerCode
        shipmentPartnerAddressTextView.text = self.orderInfo?.shipmentPartnerAddress
        shipmentAdditionalInfoTextView.text = self.orderInfo?.shipmentAdditionalInfo
        commentTextView.text = self.orderInfo?.comment
        
    }
}

class BorderedTextView: UITextView{
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    func initial(){
        clipsToBounds = true
        layer.cornerRadius = 5
        //layer.borderWidth = 1
        //layer.borderColor = #colorLiteral(red: 0.8195355535, green: 0.8196542859, blue: 0.8195096254, alpha: 1)
    }
}

