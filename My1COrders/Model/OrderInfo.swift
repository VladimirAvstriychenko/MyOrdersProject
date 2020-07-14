//
//  OrderInfo.swift
//  My1COrders
//
//  Created by Владимир on 11.05.2020.
//  Copyright © 2020 VladCorp. All rights reserved.
//

import Foundation

struct OrderInfo: Codable{
    
    let orderNumber: String
    let orderId: String
    let state: String
    let status: String
    let dateOfEvent: String
    let sumOfPayment: String
    let percentOfPayment: String
    let sumOfLoaded: String
    let percentOfLoaded: String
    let ourDebt: String
    let clientDebt: String
    let ourFullDebt: String
    let clientFullDebt: String
    let orderDate: String
    let counteragentName: String
    let counteragentInn: String
    let partnerName: String
    let partnerCode: String
    let ourOrganizationName: String
    let ourOrganizationInn: String
    let ourOrganizationKpp: String
    let warehouseName: String
    let agreementNumber: String
    let agreementDate: String
    let currency: String
    let wantedDateOfLoad: String
    let priceIncludesNds: String
    let managerName: String
    let matchingDate: String
    let taxType: String
    let comment: String
    let unit: String
    let shipmentType: String
    let contractName: String
    let contractNumber: String
    let contractDate: String
    let organizationBankAccountNumber: String
    let shipmentPartnerCode: String
    let shipmentZoneName: String
    let shipmentTimeFrom: String
    let shipmentTimeUntil: String
    let shipmentPartnerAddress: String
    let shipmentAddress: String
    let shipmentAdditionalInfo: String
    let contactPersonName: String
    let items: [Item]
   
//    let date: String
//    let counteragentName: String
//    let partnerName: String
//    let organizationName: String
//    let status: String
//    let sum: String
//    let contactPerson: String
}

struct Item: Codable {
     
    let itemCode: String
    let article: String
    let itemName: String
    let characteristikName: String
    let unitName: String
    let unitCode: String
    let loadingDate: String
    let quantity: String
    let packsQuantity: String
    let price: String
    let priceType: String
    let sum: String
    
}

struct OrderInfoResponse: Decodable{
    let orderInfo: OrderInfo
}
