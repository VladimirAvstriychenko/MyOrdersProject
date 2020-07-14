//
//  OrdersViewController.swift
//  My1COrders
//
//  Created by Владимир on 11.04.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import UIKit
import CoreData

class OrdersViewController: UIViewController, UITableViewDelegate {
 
    @IBOutlet weak var ordersTableView: UITableView!
    
    let reusableID = "OrderCell"
    var loginInfo = LoginInfo()
    var ordersUrl = ""
    var orders:[Order] = []
    var orderInfo: OrderInfo?
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.ordersTableView.register(OrdersTableViewCell.self, forCellReuseIdentifier: "OrderCell")
//        self.ordersTableView.dataSource = self

        ordersTableView.rowHeight = UITableView.automaticDimension
        ordersTableView.estimatedRowHeight = 100
        fetchOrders()
    }
    override func viewWillAppear(_ animated: Bool) {
 
    }
    
    func fetchOrders() {
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
        ordersUrl = address + "/hs/orders/GetOrdersList"
        base64String = loginInfo.token!
        
        NetworkManager.fetchDataOrders(url: ordersUrl, base64LoginString: base64String) {(orders) in
            self.orders = orders
            DispatchQueue.main.async {
                self.ordersTableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex  = indexPath.row
        fetchOrderInfo(orderDate: orders[currentIndex].date, orderNumber: orders[currentIndex].number)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let orderPageVC = segue.destination as! OrderPageViewController
        orderPageVC.orderDate = orders[currentIndex].date
        orderPageVC.orderNumber = orders[currentIndex].number
        //orderPageVC.delegate = self
//        fetchOrderInfo(orderDate: orders[currentIndex].date, orderNumber: orders[currentIndex].number)
        orderPageVC.orderInfo = orderInfo
    }
    
    func fetchOrderInfo(orderDate: String, orderNumber: String) {
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
        ordersUrl = address + "/hs/orders/GetOrderInfo"
        base64String = loginInfo.token!
        
        NetworkManager.fetchOrderInfo(url: ordersUrl, base64LoginString: base64String, orderDate: orderDate, orderNumber: orderNumber) {(orderInfo) in
            self.orderInfo = orderInfo
            
            DispatchQueue.main.async {
//                //self.fetchTextFields()
                //self.orderInfo = orderInfo
                self.performSegue(withIdentifier: "openOrder", sender: self)
            }
        }
    }
    
}


extension OrdersViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrdersTableViewCell
        configureCellNew(cell: cell, for: indexPath)
        return cell
    }
    
    private func configureCellNew(cell: OrdersTableViewCell,for indexPath: IndexPath){
        
        let value = orders[indexPath.row]
        cell.numberLabel?.text = value.number
        cell.counteragentLabel?.text = value.counteragentName
        cell.contactLabel?.text = value.contactPerson
        cell.numberLabel?.text = value.number
       // cell.dateLabel?.text = value.date
        cell.dateLabel?.text = value.date.replacingOccurrences(of: "T", with: " ", options: NSString.CompareOptions.literal, range:nil)
        
        cell.sumLabel?.text = value.sum
        if value.status == "Закрыт" {
            cell.statusView?.backgroundColor = UIColor(red: 0.0, green: 255.0, blue: 0, alpha: 0.1)}
        else if value.status.contains("К выполнению") {
            cell.statusView?.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0, alpha: 0.1)
        }
        cell.statusLabel?.text = value.status
        
    }
    
    
        
}
