//
//  OrderController.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/29.
//

import Foundation
import UIKit

class OrderController{
    static let shared = OrderController()
    
    private let baseURL = URL(string: "https://api.airtable.com/v0/appEvFweIJ3Hd40r8/order?sort[][field]=createdID&sort[][direction]=desc")!
    
    static let orderUpdateNotification = Notification.Name("OrderController.OrderUpdate")
    var order = Orders(){
        didSet{
            NotificationCenter.default.post(name: Self.orderUpdateNotification, object: nil)
        }
    }
        
    
    func uploadOrder(url:URL,data:Order,completion:@escaping (Result<String,Error>)->()){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if data != nil {
                completion(.success("發送成功"))
                print("成功")
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
    func fetchOrderItem(completion:@escaping (Result<[OrderList.Records],Error>)->()){
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if let data = data {
                do{
                    let orderReponse = try JSONDecoder().decode(OrderList.self, from: data)
                    completion(.success(orderReponse.records))
                }catch{
                    print("解碼失敗")
                    completion(.failure(error))
                }
            }else if let error = error {
                print("下載失敗")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func deleteOrderItem(orderID:String,completion:@escaping (Result<String,Error>)->()){
        guard let url = URL(string: "https://api.airtable.com/v0/appEvFweIJ3Hd40r8/order/\(orderID)") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if error == nil{
                completion(.success("刪除成功"))
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
//    func updateOrderItem(orderID:String,data:UpdateOrder,completion:@escaping (Result<String,Error>)->()){
//        guard let url = URL(string: "https://api.airtable.com/v0/appEvFweIJ3Hd40r8/order/\(orderID)") else{return}
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONEncoder().encode(data)
//        URLSession.shared.dataTask(with: request) { (data,response,error) in
//            if error == nil{
//                completion(.success("修改成功"))
//            }else{
//                completion(.failure(error!))
//            }
//        }
//    }
}
