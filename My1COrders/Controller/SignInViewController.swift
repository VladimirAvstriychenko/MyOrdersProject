//
//  SignInViewController.swift
//  PriceGet
//
//  Created by Владимир on 18.12.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import CoreData
import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var baseAddress: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    var dispatchGroup = DispatchGroup()
    
    var loginInfo = [LoginInfo]()
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            let logInfoArray = try context.fetch(fetchRequest)
            if logInfoArray.count > 0 {
                statusLabel.text = "Already logged in"
            } else {
                statusLabel.text = "Not logged in yet"
                return
                
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LoginInfo> = LoginInfo.fetchRequest()
        do{
            loginInfo = try context.fetch(fetchRequest)
        }
        catch {
            print(error.localizedDescription)
        }


    }
    
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func saveLoginInfo(baseUrl: String, token: String){
        
        deleteAllData(entity: "LoginInfo")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "LoginInfo", in: context)
        let loginInfoObject = NSManagedObject(entity: entity!, insertInto: context) as! LoginInfo
        loginInfoObject.baseUrl = baseUrl
        loginInfoObject.token = token
        
        do {
            try context.save()
            loginInfo.append(loginInfoObject)
            print("Saved! Good job!")
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Неудачная попытка", message: "Не удалось подключиться к базе!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)

        //http://192.168.0.110/UTAM/hs/orders/GetPriceTypes
        let stringUrl = baseAddress.text! + "/hs/orders/GetPriceTypes"
        guard let url = URL(string: stringUrl) else {
            self.present(alert, animated: true)
            return}

        let login = userName.text!
        let password = pwd.text!
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        var success = false
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {
                success = false
                self.dispatchGroup.leave()
                return}
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let priceTypeResponse = try decoder.decode(PriceTypeResponse.self, from: data)
                
                success = true
                self.dispatchGroup.leave()
            }
            catch {
                print("Error serialization JSON", error)
                success = false
                self.dispatchGroup.leave()
            }
        }.resume()
        dispatchGroup.notify(queue: .main){
            if success != true {
                self.present(alert, animated: true)
                
            } else {
                self.saveLoginInfo(baseUrl: self.baseAddress.text!, token: base64LoginString)
                let alert = UIAlertController(title: "Подключено!", message: "База подключена!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true)
                
            }
        }
    }
}
