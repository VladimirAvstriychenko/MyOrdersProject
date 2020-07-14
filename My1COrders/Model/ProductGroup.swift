//
//  ProductGroup.swift
//  PriceGet
//
//  Created by Владимир on 18.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import Foundation

struct ProductGroup: Codable{
    
    let name: String
    let code:String
    
    init?(name: String?, code:String?){
        guard
            let name = name,
            let code = code else {return nil}
        self.name = name
        self.code = code
    }
}

struct ProductGroupResponse: Decodable{

    let productGroups:[ProductGroup]
   
}
