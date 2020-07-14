//
//  MainOrderInfoViewController.swift
//  My1COrders
//
//  Created by Владимир on 11.05.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import UIKit
import CoreData

class MainOrderInfoViewController: UIViewController {
    
    var orderNumber = ""
    var orderDate = ""
    var orderInfo: OrderInfo?
//    var loginInfo = LoginInfo()
//    var ordersUrl = ""
    var selectType: SelectionType = .organizations
    var index: Int = 0
    

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var organizationBankAccountTextField: UITextField!
    @IBOutlet weak var counteragentTextField: UITextField!
    @IBOutlet weak var clientTextField: UITextField!
    @IBOutlet weak var agreementTextField: UITextField!
    @IBOutlet weak var contractTextField: UITextField!
    @IBOutlet weak var warehouseTextField: UITextField!
    @IBOutlet weak var taxTypeTextField: UITextField!
    @IBOutlet weak var priceIncludesNDSSwitch: UISwitch!
    
    @IBOutlet weak var contactPersonTextField: UITextField!
    @IBOutlet weak var managerTextField: UITextField!
    @IBOutlet weak var managerUnitTextField: UITextField!
    @IBOutlet weak var wantedDateOfLoadDatePicker: UIDatePicker!
    
    @IBOutlet weak var selectOrganizationButton: OrdersSelectButton!
    @IBOutlet weak var selectOrganizationBankAccountButton: OrdersSelectButton!
    @IBOutlet weak var selectCounteragentButton: OrdersSelectButton!
    @IBOutlet weak var selectPartnerButton: OrdersSelectButton!
    @IBOutlet weak var selectAgreementButton: OrdersSelectButton!
    @IBOutlet weak var selectContractButton: OrdersSelectButton!
    @IBOutlet weak var selectWarehouseButton: OrdersSelectButton!
    @IBOutlet weak var selectTaxTypeButton: OrdersSelectButton!
    @IBOutlet weak var selectContactPersonButton: OrdersSelectButton!
    @IBOutlet weak var selectManagerButton: OrdersSelectButton!
    @IBOutlet weak var selectManagerUnitButton: OrdersSelectButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var mainBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height+300)
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 2000)
        
        scrollView.contentSize = CGSize(width: 400, height: 780)
        
        //self.automaticallyAdjustsScrollViewInsets = false;
        
        scrollView.contentInsetAdjustmentBehavior = .never
        //print(mainBackView.safeAreaInsets.bottom)
       // scrollView.contentInset = UIEdgeInsets.zero
        //scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        //print(scrollView.contentOffset)
       // scrollView.contentOffset = CGPointMake(0.0, 0.0);
        
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
        numberLabel.text = self.orderInfo?.orderNumber
        dateLabel.text = self.orderInfo?.orderDate
        organizationTextField.text = self.orderInfo?.ourOrganizationName
        counteragentTextField.text = self.orderInfo?.counteragentName
        
        clientTextField.text = self.orderInfo?.partnerName
        agreementTextField.text = self.orderInfo?.agreementNumber
        contractTextField.text = self.orderInfo?.contractName
        warehouseTextField.text = self.orderInfo?.warehouseName
        taxTypeTextField.text = self.orderInfo?.taxType
        if self.orderInfo?.priceIncludesNds == "true" {
            priceIncludesNDSSwitch.isOn = true
        } else {
            priceIncludesNDSSwitch.isOn = false
        }
        contactPersonTextField.text = self.orderInfo?.contactPersonName
        managerUnitTextField.text = self.orderInfo?.unit
        //wantedDateOfLoadDatePicker.text = self.orderInfo?.wantedDateOfLoad
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectTableVC = segue.destination as! SelectTableViewController
        selectTableVC.selectionType = selectType
        
        guard let ordInfo = orderInfo else {return}
        selectTableVC.organizationInn = ordInfo.ourOrganizationInn
        selectTableVC.organizationKpp = ordInfo.ourOrganizationKpp
        selectTableVC.counteragentInn = ordInfo.counteragentInn
        if self.selectType == .partners && ordInfo.counteragentInn == ""
        {
            let alert = UIAlertController(title: "Отмена действия", message: "В контрагенте не указан ИНН! Выбор партнера без ИНН невозможен!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
            return
            
        }
        selectTableVC.delegate = self
    
    }
    func performSelectSegue() {
        performSegue(withIdentifier: "showSelectTableViewController", sender: self)
    }
    
    @IBAction func selectOrganizationButtonTaped(_ sender: UIButton) {
        switch sender {
        case selectOrganizationButton:
            selectType = .organizations
        case selectOrganizationBankAccountButton:
            selectType = .organizationBankAccounts
        case selectCounteragentButton:
            selectType = .counteragents
        case selectPartnerButton:
            selectType = .partners
        case selectAgreementButton:
            selectType = .agreements
        case selectContractButton:
            selectType = .contracts
        case selectWarehouseButton:
            selectType = .warehouses
        case selectTaxTypeButton:
            selectType = .taxTypes
        case selectContactPersonButton:
            selectType = .contactPersons
        case selectManagerButton:
            selectType = .managers
        case selectManagerUnitButton:
            selectType = .managerUnits
        default:
            return
        }
        performSelectSegue()
    }
    
}

extension MainOrderInfoViewController: selectDelegate {
  
    
    func getSelection(sender: UIViewController,
                      selectedPriceTypes: [PriceType]?,
                      selectedProductGroups: [ProductGroup]?,
                      selectedWarehouses: [Warehouse]?,
                      selectedOrganization: Organization?,
                      selectedOrganizationBankAccount: OrganizationBankAccount?,
                      selectedCounteragent: Counteragent?,
                      selectedPartner: Partner?,
                      selectedAgreement: Agreement?,
                      selectedContract: Contract?,
                      selectedTaxType: TaxType?,
                      selectedContactPerson: ContactPerson?,
                      selectedManager: Manager?,
                      selectedManagerUnit: ManagerUnit?) {
        
        switch selectType {
        case .priceTypes:
            return
        case .productGroups:
            return
        case .warehouses:
            return
        case .organizations:
            guard let selectedItem = selectedOrganization else {return}
            organizationTextField.text = selectedItem.name
        case .organizationBankAccounts:
            guard let selectedItem = selectedOrganizationBankAccount else {return}
            organizationBankAccountTextField.text = selectedItem.name
        case .counteragents:
            guard let selectedItem = selectedCounteragent else {return}
            counteragentTextField.text = selectedItem.name
        case .partners:
            guard let selectedItem = selectedPartner else {return}
            clientTextField.text = selectedItem.name
        case .agreements:
            guard let selectedItem = selectedAgreement else {return}
            agreementTextField.text = selectedItem.name
        case .contracts:
            guard let selectedItem = selectedContract else {return}
            contractTextField.text = selectedItem.name
        case .taxTypes:
            guard let selectedItem = selectedTaxType else {return}
           taxTypeTextField.text = selectedItem.name
        case .contactPersons:
            guard let selectedItem = selectedContactPerson else {return}
            contactPersonTextField.text = selectedItem.name
        case .managers:
            guard let selectedItem = selectedManager else {return}
            managerTextField.text = selectedItem.name
        case .managerUnits:
            guard let selectedItem = selectedManagerUnit else {return}
            managerUnitTextField.text = selectedItem.name
        }
        
        
    }
}


