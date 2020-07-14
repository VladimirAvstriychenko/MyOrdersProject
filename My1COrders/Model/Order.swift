//
//  Orders.swift
//  My1COrders
//
//  Created by Владимир on 12.04.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import Foundation

struct Order: Codable{
    
    let number: String
//    let date: Date
    let date: String
    let counteragentName: String
    let partnerName: String
    let organizationName: String
    let status: String
    let sum: String
    let contactPerson: String
    
//    init?(name: String?){
//        guard
//            let name = name else {return nil}
//        self.name = name
//    }
}

struct OrderResponse: Decodable{
    
    let ordersList:[Order]
   
}
