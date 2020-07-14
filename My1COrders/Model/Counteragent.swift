//
//  Counteragent.swift
//  My1COrders
//
//  Created by Владимир on 02.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

struct Counteragent: Codable{
    
    let name: String
    let inn: String
    
    init?(name: String?, inn: String?){
        guard
            let name = name,
            let inn = inn else {return nil}
        self.name = name
        self.inn = inn
    }
}

struct CounteragentResponse: Decodable{
    
    let counteragents:[Counteragent]
   
}
