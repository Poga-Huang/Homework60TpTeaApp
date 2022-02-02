//
//  OrderTVC+Extension.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/29.
//

import Foundation
import UIKit

extension OrderTableViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        self.setPickerView(selected: textField)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func setPickerView(selected sender:UITextField){
        //標記PickerView
        switch sender.tag{
        case 1:
            pickeView.tag = 1
        case 2:
            pickeView.tag = 2
        case 3:
            pickeView.tag = 3
        default:
            return
        }
        pickeView.delegate = self
        pickeView.dataSource = self
        //設定toolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = .white
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        //設定toolBar上的BarButtonItem
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        for texfield in self.pickerTextFields{
            texfield.inputView = pickeView
            texfield.inputAccessoryView = toolBar
        }
    }
    //BarButtonItem Action
    @objc func done(){
        switch pickeView.tag{
        case 1:
            pickerTextFields[0].text = Sugar.allCases[pickeView.selectedRow(inComponent: 0)].rawValue
        case 2:
            if itemDetail.hot == nil{
                pickerTextFields[1].text = noHot[pickeView.selectedRow(inComponent: 0)]
            }else if itemDetail.noIceFree != nil{
                pickerTextFields[1].text = noIceFree[pickeView.selectedRow(inComponent: 0)]
            }else{
                pickerTextFields[1].text = normal[pickeView.selectedRow(inComponent: 0)]
            }
        case 3:
            pickerTextFields[2].text = Topping.allCases[pickeView.selectedRow(inComponent: 0)].rawValue
            switch pickeView.selectedRow(inComponent: 0){
            case 0:
                toppingPrice = 0
            case 1:
                toppingPrice = 5
            case 2...7:
                toppingPrice = 10
            case 8:
                toppingPrice = 15
            default:
                toppingPrice = 0
            }
        default:
            return
        }
        tableView.endEditing(true)
    }
    @objc func cancel(){
        tableView.endEditing(true)
    }
}

extension OrderTableViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return Sugar.allCases.count
        case 2:
            guard self.itemDetail.hot != nil else{return noHot.count}
            guard self.itemDetail.noIceFree == nil else{return noIceFree.count}
            return normal.count
        case 3:
            return Topping.allCases.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return Sugar.allCases[row].rawValue
        case 2:
            guard self.itemDetail.hot != nil else{return noHot[row]}
            guard self.itemDetail.noIceFree == nil else{return noIceFree[row]}
            return normal[row]
        case 3:
            return Topping.allCases[row].rawValue
        default:
            return ""
        }
    }
    
    
}
