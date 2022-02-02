//
//  MenuResponse.swift
//  Homework60TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/26.
//

import Foundation
import UIKit

struct MenuItem:Codable{
    var records:[Records]
    struct Records:Codable{
        var fields:Fields
        struct Fields:Codable{
            var price:Int
            var name:String
            var hot:Bool?
            var category:String
            var noIceFree:Bool?
            var image:[Image]
            struct Image:Codable{
                var url:URL
            }
        }
    }
}

struct ItemDetail{
    var name:String
    var image:URL
    var price:Int
    var category:String
    var hot:Bool?
    var noIceFree:Bool?
}
