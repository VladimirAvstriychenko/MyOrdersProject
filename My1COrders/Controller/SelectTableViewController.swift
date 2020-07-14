//
//  SelectTableViewController.swift
//  PriceGet
//
//  Created by Владимир on 18.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import CoreData

internal protocol selectDelegate : NSObjectProtocol {
    func getSelection(sender:UIViewController,
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
                      selectedManagerUnit: ManagerUnit?)
}

class SelectTableViewController: UITableViewController {
    
    
    var selectionType = SelectionType.priceTypes
    
    weak internal var delegate: selectDelegate?
    
    @IBOutlet var selectionTableView: UITableView!
    
    let reusableID = "SelectedCell"
    var warehouses: [Warehouse] = []
    var warehousesUrl = "http://192.168.0.110/UTAM/hs/orders/GetWarehouses"
    var warehouseId: Int = 0
    
    var priceTypes: [PriceType] = []
    var priceTypesUrl = "http://192.168.0.110/UTAM/hs/orders/GetPriceTypes"
    var priceTypeID: Int = 0
    
    var productGroups: [ProductGroup] = []
    var productGroupsUrl = "http://192.168.0.110/UTAM/hs/orders/GetProductGroups"
    var productGroupD: Int = 0
    

    var organizations: [Organization] = []
    var organizationsUrl = ""
    var organizationID: Int = 0
    var organizationInn = ""
    var organizationKpp = ""
    
    var organizationBankAccounts: [OrganizationBankAccount] = []
    var organizationBankAccountsUrl = ""
    var organizationBankAccountID: Int = 0
    
    var counteragents: [Counteragent] = []
    var counteragentsUrl = ""
    var counteragentID: Int = 0
    var counteragentInn = ""
    
    var partners: [Partner] = []
    var partnersUrl = ""
    var partnerID: Int = 0
    
    var agreements: [Agreement] = []
    var agreementsUrl = ""
    var agreementID: Int = 0
    
    var contracts: [Contract] = []
    var contractsUrl = ""
    var contractID: Int = 0
    
    var taxTypes: [TaxType] = []
    var taxTypesUrl = ""
    var taxTypeID: Int = 0
    
    var contactPersons: [ContactPerson] = []
    var contactPersonsUrl = ""
    var contactPersonID: Int = 0
    
    var managers: [Manager] = []
    var managersUrl = ""
    var managerID: Int = 0
    
    var managerUnits: [ManagerUnit] = []
    var managerUnitsUrl = ""
    var managerUnitID: Int = 0
    
    
    var loginInfo = LoginInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(SelectTableViewCell.self, forCellReuseIdentifier: "SelectedCell")
        
        switch selectionType {
        case .priceTypes:
            fetchDataPriceTypes()
        case .productGroups:
            fetchDataProductGroups()
        case .warehouses:
            fetchDataWarehouses()
        case .organizations:
            fetchDataOrganizations()
        case .organizationBankAccounts:
            fetchDataOrganizationBankAccounts()
        case .counteragents:
            fetchDataCounteragents()
        case .partners:
            fetchDataPartners()
        case .agreements:
            fetchDataAgreements()
        case .contracts:
            fetchDataContracts()
        case .taxTypes:
            fetchDataTaxTypes()
        case .contactPersons:
            fetchDataContactPersons()
        case .managers:
            fetchDataManagers()
        case .managerUnits:
            fetchDataManagerUnits()
            
        }
        
    }
    

    @IBAction func selectPressed(_ sender: UIButton) {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            // 1
            var selectedPriceTypes = [PriceType]()
            var selectedProductGroups = [ProductGroup]()
            var selectedWarehouses = [Warehouse]()
            var selectedOrganization: Organization?
            var selectedOrganizationBankAccount: OrganizationBankAccount?
            var selectedCounteragent: Counteragent?
            var selectedPartner: Partner?
            var selectedAgreement: Agreement?
            var selectedContract: Contract?
            var selectedTaxType: TaxType?
            var selectedContactPerson: ContactPerson?
            var selectedManager: Manager?
            var selectedManagerUnit: ManagerUnit?
            
            for indexPath in selectedRows  {
                
                switch self.selectionType {
                case .priceTypes:
                    let item = PriceType(name:priceTypes[indexPath.row].name)
                    selectedPriceTypes.append(item!)
                case .productGroups:
                    let item = ProductGroup(name:productGroups[indexPath.row].name,code: productGroups[indexPath.row].code)
                    selectedProductGroups.append(item!)
                case .warehouses:
                    let item = Warehouse(name:warehouses[indexPath.row].name)
                    selectedWarehouses.append(item!)
                case .organizations:
                    selectedOrganization = organizations[indexPath.row]
                case .organizationBankAccounts:
                    selectedOrganizationBankAccount = organizationBankAccounts[indexPath.row]
                case .counteragents:
                    selectedCounteragent = counteragents[indexPath.row]
                case .partners:
                    selectedPartner = partners[indexPath.row]
                case .agreements:
                    selectedAgreement = agreements[indexPath.row]
                case .contracts:
                    selectedContract = contracts[indexPath.row]
                case .taxTypes:
                    selectedTaxType = taxTypes[indexPath.row]
                case .contactPersons:
                    selectedContactPerson = contactPersons[indexPath.row]
                case .managers:
                    selectedManager = managers[indexPath.row]
                case .managerUnits:
                    selectedManagerUnit = managerUnits[indexPath.row]
                }
            }
            
            
            self.delegate!.getSelection(sender: self,
                                        selectedPriceTypes: selectedPriceTypes,
                                        selectedProductGroups: selectedProductGroups,
                                        selectedWarehouses: selectedWarehouses,
                                        selectedOrganization: selectedOrganization,
                                        selectedOrganizationBankAccount: selectedOrganizationBankAccount,
                                        selectedCounteragent: selectedCounteragent,
                                        selectedPartner: selectedPartner,
                                        selectedAgreement: selectedAgreement,
                                        selectedContract: selectedContract,
                                        selectedTaxType: selectedTaxType,
                                        selectedContactPerson: selectedContactPerson,
                                        selectedManager: selectedManager,
                                        selectedManagerUnit: selectedManagerUnit)
            navigationController!.popViewController( animated: true)
        }
    }
    func fetchDataWarehouses() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        warehousesUrl = address + "/hs/orders/GetWarehouses"
        base64String = loginInfo.token!
        
        NetworkManager.fetchDataWarehouses(url: warehousesUrl, base64LoginString: base64String) {(warehouses) in
            self.warehouses = warehouses
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
        
    }
    
    func fetchDataProductGroups() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        productGroupsUrl = address + "/hs/orders/GetProductGroups"
        base64String = loginInfo.token!
        
        NetworkManager.fetchDataProductGroups(url: productGroupsUrl, base64LoginString: base64String) {(productGroups) in
            self.productGroups = productGroups
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
        
    }
    
    func fetchDataPriceTypes() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        priceTypesUrl = address + "/hs/orders/GetPriceTypes"
        base64String = loginInfo.token!
        
        NetworkManager.fetchDataPriceTypes(url: priceTypesUrl, base64LoginString: base64String) {(priceTypes) in
            self.priceTypes = priceTypes
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension SelectTableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
    }
}

extension SelectTableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.selectionType {
        case .priceTypes:
            return self.priceTypes.count
        case .productGroups:
            return self.productGroups.count
        case .warehouses:
            return self.warehouses.count
        case .organizations:
            return self.organizations.count
        case .organizationBankAccounts:
            return self.organizationBankAccounts.count
        case .counteragents:
            return self.counteragents.count
        case .partners:
            return self.partners.count
        case .agreements:
            return self.agreements.count
        case .contracts:
            return self.contracts.count
        case .taxTypes:
            return self.taxTypes.count
        case .contactPersons:
            return self.contactPersons.count
        case .managers:
            return self.managers.count
        case .managerUnits:
            return self.managerUnits.count
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedCell") as! SelectTableViewCell
        configureCellNew(cell: cell, for: indexPath)
        return cell
    }
    
    private func configureCellNew(cell: SelectTableViewCell,for indexPath: IndexPath){
        
        
        switch self.selectionType {
        case .priceTypes:
            let value = priceTypes[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = ""
        case .productGroups:
            let value = productGroups[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = value.code
        case .warehouses:
            let value = warehouses[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = ""
        case .organizations:
            let value = organizations[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = value.inn
        case .organizationBankAccounts:
            let value = organizationBankAccounts[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = value.number
            cell.additionalLabel?.text = value.bank
        case .counteragents:
            let value = counteragents[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = value.inn
        case .partners:
            let value = partners[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = value.code
        case .agreements:
            let value = agreements[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = value.number
            cell.additionalLabel?.text = value.date
        case .contracts:
            let value = contracts[indexPath.row]
            cell.valueLabel?.text = value.name
            cell.codeLabel?.text = value.number
            cell.additionalLabel?.text = value.date
        case .taxTypes:
            let value = taxTypes[indexPath.row]
            cell.valueLabel?.text = value.name
        case .contactPersons:
            let value = contactPersons[indexPath.row]
            cell.valueLabel?.text = value.name
        case .managers:
            let value = managers[indexPath.row]
            cell.valueLabel?.text = value.name
        case .managerUnits:
            let value = managerUnits[indexPath.row]
            cell.valueLabel?.text = value.name
            
        }
        
        
    }
    
    func fetchDataOrganizations() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetOrganizations"
        base64String = loginInfo.token!
        
        NetworkManager.fetchOrganizations(url: organizationsUrl, base64LoginString: base64String) {(organizations) in
            self.organizations = organizations
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataOrganizationBankAccounts() {
        //guard let org = organization else {return}
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetOrganizationBankAccounts"
        base64String = loginInfo.token!
        
        NetworkManager.fetchOrganizationBankAccounts(url: organizationsUrl, base64LoginString: base64String, organizationInn: organizationInn, organizationKpp: organizationKpp) {(returnItems) in
            self.organizationBankAccounts = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataCounteragents() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetCounteragents"
        base64String = loginInfo.token!
        
        NetworkManager.fetchCounteragents(url: organizationsUrl, base64LoginString: base64String) {(returnItems) in
            self.counteragents = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataPartners() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetPartners"
        base64String = loginInfo.token!
        
        NetworkManager.fetchPartners(url: organizationsUrl, base64LoginString: base64String, counteragentInn: counteragentInn) {(returnItems) in
            self.partners = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataAgreements() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetAgreements"
        base64String = loginInfo.token!
        
        NetworkManager.fetchAgreements(url: organizationsUrl, base64LoginString: base64String) {(returnItems) in
            self.agreements = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataContracts() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetContracts"
        base64String = loginInfo.token!
        
        NetworkManager.fetchContracts(url: organizationsUrl, base64LoginString: base64String) {(returnItems) in
            self.contracts = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataTaxTypes() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetTaxTypes"
        base64String = loginInfo.token!
        
        NetworkManager.fetchTaxTypes(url: organizationsUrl, base64LoginString: base64String) {(returnItems) in
            self.taxTypes = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataContactPersons() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetContactPersons"
        base64String = loginInfo.token!
        
        NetworkManager.fetchContactPersons(url: organizationsUrl, base64LoginString: base64String) {(returnItems) in
            self.contactPersons = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataManagers() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetUsers"
        base64String = loginInfo.token!
        
        NetworkManager.fetchManagers(url: organizationsUrl, base64LoginString: base64String) {(returnItems) in
            self.managers = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
    func fetchDataManagerUnits() {
        //Getting current base address and access token
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                loginInfo = logInfoArray[0]
            } else {return}
        }
        catch {
            print(error.localizedDescription)
        }
        var address = ""
        var base64String = ""
        address = loginInfo.baseUrl!
        organizationsUrl = address + "/hs/orders/GetManagerUnits"
        base64String = loginInfo.token!
        
        NetworkManager.fetchManagerUnits(url: organizationsUrl, base64LoginString: base64String) {(returnItems) in
            self.managerUnits = returnItems
            DispatchQueue.main.async {
                self.selectionTableView.reloadData()
            }
        }
    }
    
}
