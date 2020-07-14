//
//  Manager.swift
//  My1COrders
//
//  Created by Владимир on 02.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

struct Manager: Codable{
    
    let name: String
    
    init?(name: String?){
        guard
            let name = name else {return nil}
        self.name = name

    }
}

struct ManagerResponse: Decodable{
    
    let usersList:[Manager]
   
}
