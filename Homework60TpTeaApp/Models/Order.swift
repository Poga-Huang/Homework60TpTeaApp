//
//  Order.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/27.
//

import Foundation

//上傳用
struct Order:Codable{
    var records:[Records]
    struct Records:Codable{
        var fields:Fields
        struct Fields:Codable{
            var ordererName:String
            var imageURL:URL
            var drinksName:String
            var drinksTemperature:String
            var drinksSugar:String
            var drinksTopping:String
            var remark:String?
            var quantity:Int
            var price:Int
            var createdID:String
        }
    }
}

//記錄用
struct Orders:Codable{
    var orders:[Order.Records]
    
    init(orders: [Order.Records] = []) {
        self.orders = orders
    }
}
//下載用
struct OrderList:Codable{
    var records:[Records]
    struct Records:Codable{
        var id:String
        var fields:Order.Records.Fields
    }
}
