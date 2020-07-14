//
//  PriceList.swift
//  PriceGet
//
//  Created by Владимир on 22.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import Foundation

struct PriceList: Codable{
    var priceListUrl: String
    init?(priceListUrl: String?){
        guard
            let priceListUrl = priceListUrl else {return nil}
            self.priceListUrl = priceListUrl
    }
}

struct PriceListResponse: Decodable{
    
    let priceListUrl:String?
    
}
