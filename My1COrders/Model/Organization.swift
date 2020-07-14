//
//  Organizations.swift
//  My1COrders
//
//  Created by Владимир on 02.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import Foundation

struct Organization: Codable{
    
    let name: String
    let inn: String
    let kpp: String
    
    init?(name: String?, inn: String?, kpp: String?){
        guard
            let name = name,
            let inn = inn,
            let kpp = kpp else {return nil}
        self.name = name
        self.inn = inn
        self.kpp = kpp
    }
}

struct OrganizationResponse: Decodable{
    
    let organizations:[Organization]
   
}

