//
//  TaxType.swift
//  My1COrders
//
//  Created by Владимир on 02.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

struct TaxType: Codable{
    
    let name: String
    let code: String
    
    init?(name: String?, code: String?){
        guard
            let name = name,
            let code = code else {return nil}
        self.name = name
        self.code = code
    }
}

struct TaxTypeResponse: Decodable{
    
    let taxTypes:[TaxType]
   
}

