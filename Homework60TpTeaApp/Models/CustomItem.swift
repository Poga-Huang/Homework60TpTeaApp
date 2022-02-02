//
//  enum.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/27.
//

import Foundation

let noHot = ["多冰","標準","微冰","去冰","常溫"]
let noIceFree = ["多冰","標準","微冰","常溫","熱"]
let normal = ["多冰","標準","微冰","去冰","常溫","熱"]

enum Sugar:String,CaseIterable{
    case standard = "標準"
    case lessSugar = "八分糖"
    case halfSugar = "半糖"
    case quarterSugar = "微糖"
    case sugarFree = "無糖"
}
enum Topping:String,CaseIterable{
    case none = "無加料"
    case plum = "+5甘梅兩顆"
    case smallBubble = "+10珍珠"
    case redBean = "+10紅豆"
    case bigBubble = "+10波霸"
    case lemon = "+10檸檬"
    case jelly = "+10粉角"
    case gressJelly = "+10仙草"
    case oat = "+15燕麥"
}

