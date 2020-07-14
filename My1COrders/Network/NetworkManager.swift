//
//  NetworkManager.swift
//  PriceGet
//
//  Created by Владимир on 22.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NetworkManager {
    
    static func fetchDataProductGroups(url: String, base64LoginString: String, completion: @escaping (_ productGroups: [ProductGroup]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let productGroupsResponse = try decoder.decode(ProductGroupResponse.self, from: data)
                completion(productGroupsResponse.productGroups)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchDataPriceTypes(url: String, base64LoginString: String, completion: @escaping (_ priceTypes: [PriceType]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let priceTypeResponse = try decoder.decode(PriceTypeResponse.self, from: data)
                completion(priceTypeResponse.priceTypes)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchDataWarehouses(url: String, base64LoginString: String, completion: @escaping (_ warehouses: [Warehouse]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let warehouseResponse = try decoder.decode(WarehouseResponse.self, from: data)
                completion(warehouseResponse.warehouses)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func getPriceList(url: String, base64LoginString: String, priceTypes: [PriceType], productGroups: [ProductGroup], warehouses: [Warehouse], withStocks: Bool, completion: @escaping (_ priceListUrl: String?) -> ()) {
        guard let url = URL(string: url) else {return}

//        let login = "GatewayUser"
//        let password = "123"
//        let loginString = String(format: "%@:%@", login, password)
//        let loginData = loginString.data(using: String.Encoding.utf8)!
//        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        struct Parameters: Codable{
            var priceTypes = [PriceType]()
            var productGroups = [ProductGroup]()
            var warehouses = [Warehouse]()
            var withStocks = false
        }
        
        var params = Parameters()
        params.priceTypes = priceTypes
        params.productGroups = productGroups
        params.warehouses = warehouses
        params.withStocks = withStocks
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let jsonData = try encoder.encode(params)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            request.httpBody = jsonData

        } catch { print(error) }

        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                print(String(decoding: data, as: UTF8.self))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let priceListResponse = try decoder.decode(PriceListResponse.self, from: data)
                completion(priceListResponse.priceListUrl)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchDataOrders(url: String, base64LoginString: String, completion: @escaping (_ orders: [Order]) -> ()) {
            guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        struct Parameters: Codable{
            var stringParameter = ""
        }
        
        let params = Parameters()
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            let jsonData = try encoder.encode(params)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            request.httpBody = jsonData
            
        } catch { print(error) }
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data1 = data else {return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let orderResponse = try decoder.decode(OrderResponse.self, from: data1)
                completion(orderResponse.ordersList)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchOrderInfo(url: String, base64LoginString: String, orderDate: String, orderNumber: String, completion: @escaping (_ orderInfo: OrderInfo) -> ()) {
            guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        struct Parameters: Codable{
            var orderDate = ""
            var orderNumber = ""
        }
        
        var params = Parameters()
        params.orderDate = orderDate
        params.orderNumber = orderNumber
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            let jsonData = try encoder.encode(params)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            request.httpBody = jsonData
            
        } catch { print(error) }
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data1 = data else {return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonString = String(data: data1, encoding: .utf8)!
                print(jsonString)
                
                let orderInfoResponse = try decoder.decode(OrderInfo.self, from: data1)
                completion(orderInfoResponse)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchOrganizations(url: String, base64LoginString: String, completion: @escaping (_ organizations: [Organization]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let organizationResponse = try decoder.decode(OrganizationResponse.self, from: data)
                completion(organizationResponse.organizations)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchOrganizationBankAccounts(url: String, base64LoginString: String, organizationInn: String, organizationKpp: String, completion: @escaping (_ organizationBankAccounts: [OrganizationBankAccount]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        struct Parameters: Codable{
            var organizationInn = ""
            var organizationKpp = ""
        }
        
        var params = Parameters()
        params.organizationInn = organizationInn
        params.organizationKpp = organizationKpp
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            let jsonData = try encoder.encode(params)
            request.httpBody = jsonData
            
        } catch { print(error) }
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(OrganizationBankAccountResponse.self, from: data)
                completion(response.bankAccounts)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchCounteragents(url: String, base64LoginString: String, completion: @escaping (_ counteragents: [Counteragent]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(CounteragentResponse.self, from: data)
                completion(response.counteragents)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchPartners(url: String, base64LoginString: String, counteragentInn: String, completion: @escaping (_ partners: [Partner]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        struct Parameters: Codable{
            var counteragentInn = ""
        }
        
        var params = Parameters()
        params.counteragentInn = counteragentInn
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            let jsonData = try encoder.encode(params)
            request.httpBody = jsonData
            
        } catch { print(error) }
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(PartnerResponse.self, from: data)
                completion(response.partnersList)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchAgreements(url: String, base64LoginString: String, completion: @escaping (_ agreements: [Agreement]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(AgreementResponse.self, from: data)
                completion(response.agreements)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchContracts(url: String, base64LoginString: String, completion: @escaping (_ contracts: [Contract]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(ContractResponse.self, from: data)
                completion(response.agreements)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchTaxTypes(url: String, base64LoginString: String, completion: @escaping (_ taxTypes: [TaxType]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(TaxTypeResponse.self, from: data)
                completion(response.taxTypes)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchContactPersons(url: String, base64LoginString: String, completion: @escaping (_ contactPersons: [ContactPerson]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(ContactPersonResponse.self, from: data)
                completion(response.contactPersonList)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchManagers(url: String, base64LoginString: String, completion: @escaping (_ managers: [Manager]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(ManagerResponse.self, from: data)
                completion(response.usersList)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    
    static func fetchManagerUnits(url: String, base64LoginString: String, completion: @escaping (_ managerUnits: [ManagerUnit]) -> ()) {
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let jsonString = String(data: data, encoding: .utf8)!
                print(jsonString)
                
                let response = try decoder.decode(ManagerUnitResponse.self, from: data)
                completion(response.managerUnits)
                
            }
            catch {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
    

}
