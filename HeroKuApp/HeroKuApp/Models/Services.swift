//
//  Services.swift
//  HeroKuApp
//
//  Created by Azhar on 25/01/19.
//  Copyright © 2019 Orbysol Systems Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

let BASE_URL = "http://apac-ar-test.herokuapp.com"
let REGISTER = "users.json"
let LOGIN = "users/sign_in.json"
let ALL_BOOKINGS = "bookings.json"
let DESKS = "desks.json"
let BOOK_SEAT = "bookings.json"

class Services: NSObject {
    
    func registerService(email: String, password: String, confirmPassword: String)  {
      
        let config = URLSessionConfiguration.default // Session Configuration
        config.httpAdditionalHeaders = ["Accept": "application/json","Content-Type": "application/json"]
        let session = URLSession(configuration: config) // Load configuration into Session
        let urlString = String.init(format:"%@/%@?user[email]=%@&user[password]=%@&user[password_confirmation]=%@",BASE_URL,REGISTER,email,password,confirmPassword)
        
        let url = URL.init(string: urlString)

        let urlRequest = NSMutableURLRequest.init(url: url!)
        urlRequest.httpMethod = "POST"

        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    print("Error : \(error!.localizedDescription)")
                }
            } else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        let token = json["authentication_token"]
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(email, forKey: "email")
                         UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: .DidReceiveRegistrationResponce, object: nil)
                    }
                } catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        print("Error :Unable to reach server ")
                    }
                }
            }
        })
        task.resume()
    }
    
    func loginUser(email:String, password:String)  {
        
        let config = URLSessionConfiguration.default // Session Configuration
        config.httpAdditionalHeaders = ["Accept": "application/json","Content-Type": "application/json"]
        let session = URLSession(configuration: config) // Load configuration into Session
        let urlString = String.init(format:"%@/%@?user[email]=%@&user[password]=%@",BASE_URL,LOGIN,email,password)
        
        let url = URL.init(string: urlString)
        
        let urlRequest = NSMutableURLRequest.init(url: url!)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    print("Error : \(error!.localizedDescription)")
                }
            } else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: .DidReceiveLoginResponce, object: nil)
                    }
                } catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        print("Error :Unable to reach server ")
                    }
                }
            }
        })
        task.resume()
    }

    func getAllSeatsBooking() {
        
        let config = URLSessionConfiguration.default // Session Configuration
        config.httpAdditionalHeaders = ["Accept": "application/json","Content-Type": "application/json"]
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let email = UserDefaults.standard.object(forKey: "email") as! String
        let token = UserDefaults.standard.object(forKey: "token") as! String
        let urlString = String.init(format:"%@/%@?user[email]=%@&authentication_token=%@",BASE_URL,ALL_BOOKINGS,email,token)
        
        let url = URL.init(string: urlString)
        
        let urlRequest = NSMutableURLRequest.init(url: url!)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    print("Error : \(error!.localizedDescription)")
                }
            } else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue(json, forKey: "bookings")
                        userDefaults.synchronize()
                        NotificationCenter.default.post(name: .DidReceiveSeatsResponce, object: nil)
                    }
                } catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        print("Error :Unable to reach server ")
                    }
                }
            }
        })
        task.resume()
    }
    
    func getAvailabeDesks() {
        
        let email = UserDefaults.standard.object(forKey: "email") as! String
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let config = URLSessionConfiguration.default // Session Configuration
        config.httpAdditionalHeaders = ["Accept": "application/json","Content-Type": "application/json","X-User-Email":email,"X-User-Token":token]
        let session = URLSession(configuration: config) // Load configuration into Session
        //http://apac-ar-test.herokuapp.com/desks.json
        let urlString = String.init(format:"%@/%@",BASE_URL,DESKS)
        let url = URL.init(string: urlString)
        
        let urlRequest = NSMutableURLRequest.init(url: url!)
        urlRequest.httpMethod = "GET"

        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    print("Error : \(error!.localizedDescription)")
                }
            } else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        print(json)
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue(json, forKey: "desks")
                        userDefaults.synchronize()
                        NotificationCenter.default.post(name: .DidReceiveDesksResponce, object: nil)
                    }
                } catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        print("Error :Unable to reach server ")
                    }
                }
            }
        })
        task.resume()
    }
    
   
    
    func bookSeat(deskid:String,bookedAt:String,bookedFrom:String,bookedTo:String) {
        
        let config = URLSessionConfiguration.default // Session Configuration
        config.httpAdditionalHeaders = ["Accept": "application/json","Content-Type": "application/json"]
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let email = UserDefaults.standard.object(forKey: "email") as! String
        let token = UserDefaults.standard.object(forKey: "token") as! String
        let urlString = String.init(format:"%@/%@?user[email]=%@&authentication_token=%@&booking[desk_id]=%@&booking[booked_at]=%@&booking[booked_from]=%@&booking[booked_to]=%@",BASE_URL,BOOK_SEAT,email,token,deskid,bookedAt,bookedFrom,bookedTo)
  
        let url = URL.init(string: urlString)
        
        let urlRequest = NSMutableURLRequest.init(url: url!)
        urlRequest.httpMethod = "POST"
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    print("Error : \(error!.localizedDescription)")
                }
            } else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                    }
                } catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        print("Error :Unable to reach server ")
                    }
                }
            }
        })
        task.resume()
    }
}
