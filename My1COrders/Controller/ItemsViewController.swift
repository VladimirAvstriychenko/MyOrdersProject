//
//  ItemsViewController.swift
//  My1COrders
//
//  Created by Владимир on 10.06.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, UITableViewDelegate {
    
    var items:[Item]? = []
    var orderInfo: OrderInfo?
    var currentIndex: Int = 0
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = 100
        items = orderInfo?.items
        //fetchItems()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "showItem", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            let itemVC = segue.destination as! ItemViewController
            itemVC.item = items![currentIndex]
        }
    }
    
 
}

extension ItemsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.items?.count else {return 0}
        return count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemsTableViewCell
        configureCellNew(cell: cell, for: indexPath)
        return cell
    }
    
    private func configureCellNew(cell: ItemsTableViewCell,for indexPath: IndexPath){
        
        guard let value = items?[indexPath.row] else {return}
        cell.itemNameTextField?.text = value.itemName
        
        cell.sumTextField?.text = value.sum
        cell.pricetTextField?.text = value.price
        cell.characteristikNameTextField?.text = value.characteristikName
        
        cell.quantityTextField?.text = value.quantity
        
        //        cell.layer.borderColor = UIColor.black.cgColor
        //        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 8
//        cell.clipsToBounds = true
        if indexPath.row%2 == 1 {
            cell.backgroundColor = #colorLiteral(red: 0.9311327338, green: 0.9311327338, blue: 0.9311327338, alpha: 1)
        }
        
    }
    
    
        
}
