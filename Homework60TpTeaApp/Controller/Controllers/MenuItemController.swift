//
//  MenuItemController.swift
//  Homework60TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/26.
//

import Foundation
import UIKit

//APIKey
public let apiKey = "keyuuszf5krfcrpdZ"

class MenuItemController{
    
    static let shared = MenuItemController()
    private let baseURL = URL(string: "https://api.airtable.com/v0/appEvFweIJ3Hd40r8/menu?sort[][field]=category&sort[][direction]=asc")!
    
    func fetchMenuItem(completion:@escaping (Result<MenuItem,Error>)->()){
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            if let data = data {
                do{
                    let menuItemResponse = try JSONDecoder().decode(MenuItem.self, from: data)
                    
                    completion(.success(menuItemResponse))
                }catch{
                    completion(.failure(error))
                }
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
   
    func fetchItemImage(url:URL,completion:@escaping (Result<UIImage,Error>)->()){
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if let data = data,let image = UIImage(data: data) {
                completion(.success(image))
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
}
