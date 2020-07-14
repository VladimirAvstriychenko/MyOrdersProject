//
//  Agreement.swift
//  My1COrders
//
//  Created by Владимир on 02.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

struct Agreement: Codable{
    
    let name: String
    let number: String
    let date: String
    
    init?(name: String?, number: String?, date: String?){
        guard
            let name = name,
            let number = number,
            let date = date else {return nil}
        self.name = name
        self.number = number
        self.date = date
    }
}

struct AgreementResponse: Decodable{
    
    let agreements:[Agreement]
   
}
