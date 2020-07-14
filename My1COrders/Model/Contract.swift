//
//  Contract.swift
//  My1COrders
//
//  Created by Владимир on 02.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

struct Contract: Codable{
    
    let name: String
    let number: String
    let date: String
    let status: String
    let dateEnd: String
    
    init?(name: String?, number: String?, date: String?, status: String?, dateEnd: String?){
        guard
            let name = name,
            let number = number,
            let date = date,
            let status = status,
            let dateEnd = dateEnd else {return nil}
        self.name = name
        self.number = number
        self.date = date
        self.status = status
        self.dateEnd = dateEnd
    }
}

struct ContractResponse: Decodable{
    
    let agreements:[Contract]
   
}
