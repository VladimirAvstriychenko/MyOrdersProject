//
//  OrganizationBankAccount.swift
//  My1COrders
//
//  Created by Владимир on 02.07.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

struct OrganizationBankAccount: Codable{
    
    let name: String
    let number: String
    let bank: String
    
    init?(name: String?, number: String?, bank: String?){
        guard
            let name = name,
            let number = number,
            let bank = bank else {return nil}
        self.name = name
        self.number = number
        self.bank = bank
    }
}

struct OrganizationBankAccountResponse: Decodable{
    
    let bankAccounts:[OrganizationBankAccount]
   
}
