//
//  SelectOptionsViewController.swift
//  PriceGet
//
//  Created by Владимир on 18.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import CoreData

class SelectOptionsViewConroller: UIViewController {
    
    @IBOutlet weak var warehouseTextField: UITextField!
    @IBOutlet weak var priceTypesTextField: UITextField!
    @IBOutlet weak var productGroupsTextField: UITextField!
    @IBOutlet weak var withStocksSwitch: UISwitch!
    @IBOutlet weak var getPriceListButton: UIButton!
    
    @IBOutlet weak var warehousesButton: UIButton!
    @IBOutlet weak var priceTypesButton: UIButton!
    @IBOutlet weak var productGroupsButton: UIButton!
    
    var selectType = SelectionType.priceTypes
    var priceLists:[CorePriceList] = []
    
    var warehouses:[Warehouse] = []
    var productGroups:[ProductGroup] = []
    var priceTypes:[PriceType] = []
    
    var loginInfo = LoginInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CorePriceList> = CorePriceList.fetchRequest()
        do{
            priceLists = try context.fetch(fetchRequest)
        }
        catch {
            print(error.localizedDescription)
        }
       
        
        //getPriceListButton.layer.borderWidth = 2
        getPriceListButton.layer.borderColor = UIColor.black.cgColor
        getPriceListButton.layer.cornerRadius = 5
        getPriceListButton.clipsToBounds = true
        
        //checkLoggedIn()
    }
    
    @IBAction func getPriceListButtonPressed(_ sender: UIButton) {
        
        
        
        //Getting current base address
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            
            //loginInfo = try context.fetch(fetchRequest)[0]
            
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {
                let alert = UIAlertController(title: "Неудачная попытка", message: "Не удалось подключиться к базе!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true)
                return}
            
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""        
        address = loginInfo.baseUrl!
        base64String = loginInfo.token!
        
        NetworkManager.getPriceList(url: "\(address)/hs/orders/GetPriceList", base64LoginString: base64String, priceTypes: priceTypes, productGroups: productGroups, warehouses: warehouses, withStocks: withStocksSwitch.isOn){(priceListLink) in
            guard let priceListLink = priceListLink else {return}
            self.savePriceList(priceListUrl: priceListLink)
            
        }
    }
    
    func savePriceList(priceListUrl: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CorePriceList", in: context)
        let corePriceListObject = NSManagedObject(entity: entity!, insertInto: context) as! CorePriceList
        corePriceListObject.priceListUrl = priceListUrl
        
        do {
            try context.save()
            priceLists.append(corePriceListObject)
            //print("Saved! Good job!")
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func warehousesLongPressed(_ sender: UILongPressGestureRecognizer) {
//        if sender.state != UIGestureRecognizer.State.began {
//            selectType = SelectionType.warehouses
//            performSegue(withIdentifier: "openSelectionTableVC", sender: self)
//        }
        
    }
    
    @IBAction func priceTypesLongPressed(_ sender: UILongPressGestureRecognizer) {
//        if sender.state != UIGestureRecognizer.State.began {
//            selectType = SelectionType.priceTypes
//            performSegue(withIdentifier: "openSelectionTableVC", sender: self)
//        }
    }
    
    @IBAction func productGroupsLongPressed(_ sender: UILongPressGestureRecognizer) {
//        if sender.state != UIGestureRecognizer.State.began {
//            selectType = SelectionType.productGroups
//            performSegue(withIdentifier: "openSelectionTableVC", sender: self)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let selectTableVC = segue.destination as! SelectTableViewController
        selectTableVC.selectionType = selectType
        selectTableVC.delegate = self
        
    }
    
    @IBAction func warehousesButtonPressed(_ sender: UIButton) {
        selectType = SelectionType.warehouses
        performSegue(withIdentifier: "openSelectionTableVC", sender: self)
    }
    
    @IBAction func priceTypesButtonPressed(_ sender: Any) {
        selectType = SelectionType.priceTypes
        performSegue(withIdentifier: "openSelectionTableVC", sender: self)
    }
    
    @IBAction func producGroupsPressed(_ sender: Any) {
        selectType = SelectionType.productGroups
        performSegue(withIdentifier: "openSelectionTableVC", sender: self)
    }
    
    func updateOptionsFields(){
        warehouseTextField.text = ""
        var text = ""

        for item in warehouses {
            text = text + item.name + "; "
        }
        warehouseTextField.text = text
        
        text = ""
        for item in priceTypes {
            text = text + item.name + "; "
        }
        priceTypesTextField.text = text
        
        text = ""
        for item in productGroups {
            text = text + item.name + "; "
        }
        productGroupsTextField.text = text
        
    }
    @IBAction func selectOptionsViewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
//    private func checkLoggedIn(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//
//        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
//        do{
//            let logInfoArray = try context.fetch(fetchRequest)
//            if logInfoArray.count > 0 {
//                print("Already logged in")
//            } else {
//                print("Not logged in yet")
//                DispatchQueue.main.async {
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let signInViewController1 = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//                    signInViewController1.modalPresentationStyle = .fullScreen
//                    self.present(signInViewController1, animated: true)
//                    return
//                }
//            }
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//    }
}

extension SelectOptionsViewConroller: selectDelegate {    
    
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
            priceTypes = selectedPriceTypes!
        case .productGroups:
            productGroups = selectedProductGroups!
        case .warehouses:
            warehouses = selectedWarehouses!
        case .organizations:
            return
        case .organizationBankAccounts:
            return
        case .counteragents:
            return
        case .partners:
            return
        case .agreements:
            return
        case .contracts:
            return
        case .taxTypes:
            return
        case .contactPersons:
            return
        case .managers:
            return
        case .managerUnits:
            return
        }
        
        updateOptionsFields()
        
    }
}
