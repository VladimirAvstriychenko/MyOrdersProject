//
//  PriceType.swift
//  PriceGet
//
//  Created by Владимир on 18.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import Foundation

struct PriceType: Codable{
    
    let name: String
    
    init?(name: String?){
        guard
            let name = name else {return nil}
        self.name = name
    }
}

struct PriceTypeResponse: Decodable{
    
    let priceTypes:[PriceType]
   
}
