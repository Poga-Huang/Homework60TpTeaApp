//
//  OrderTableViewController.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/28.
//

import UIKit
enum Remind{
    case error
    case success
}

class OrderTableViewController: UITableViewController {
    
    //infoView
    @IBOutlet weak var drinksImageView: UIImageView!
    @IBOutlet weak var drinksCategoryLabel: UILabel!
    @IBOutlet weak var drinksNameLabel: UILabel!
    @IBOutlet weak var drinksPriceLabel: UILabel!
    //MustInput
    @IBOutlet weak var ordererNameTextField: UITextField!
    @IBOutlet weak var sugarTextField: UITextField!
    @IBOutlet weak var tempTextField: UITextField!
    @IBOutlet weak var toppingTextField: UITextField!
    @IBOutlet var pickerTextFields: [UITextField]!
    //othersInput
    @IBOutlet weak var remarkTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    //button
    @IBOutlet weak var sendOrderButton: UIButton!
    // variable
    //總額用{get}計算
    var totalPrice:Int{
        get{
            return (itemDetail.price+toppingPrice)*quantity
        }
    }
    //加料價格
    var toppingPrice = 0{
        didSet{
            sendOrderButton.configuration?.title = "送出訂單$\(totalPrice)"
            print(totalPrice)
        }
    }
    //總數
    var quantity = 1{
        didSet{
            quantityLabel.text = "\(quantity)"
            sendOrderButton.configuration?.title = "送出訂單$\(totalPrice)"
            print(totalPrice)
        }
    }
    internal let pickeView = UIPickerView()
    
    var itemDetail:ItemDetail
    init?(coder:NSCoder,itemDetail:ItemDetail){
        self.itemDetail = itemDetail
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init
        self.navigationItem.title = "訂購單"
        
        drinksCategoryLabel.text = itemDetail.category
        drinksNameLabel.text = "-\(itemDetail.name)-"
        drinksPriceLabel.text = "$\(itemDetail.price)"
        sendOrderButton.configuration?.title = "送出訂單$\(itemDetail.price)"
        MenuItemController.shared.fetchItemImage(url: itemDetail.image) { result in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    self.drinksImageView.image = image
                }
            case .failure(_):
                print("error")
            }
        }
        
        tapGesture()
        
        //delegate
        ordererNameTextField.delegate = self
        sugarTextField.delegate = self
        tempTextField.delegate = self
        toppingTextField.delegate = self
        remarkTextField.delegate = self
        
        
    }
    func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard(){
        tableView.endEditing(true)
    }
    
    @IBAction func updateQuantity(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            quantity += 1
        case 1:
            if quantity > 1{
                quantity -= 1
            }else{
                showRemindAlert(title: "提醒", message: "不得少於一杯", remind: .error)
            }
        default:
            return
        }
    }
    //送出訂單
    @IBAction func sendOutOrder(_ sender: UIButton) {
        guard ordererNameTextField.text != "" else{return showRemindAlert(title: "提醒", message: "請輸入訂購人姓名,感謝配合", remind: .error)}
        guard sugarTextField.text != "" else{return showRemindAlert(title: "提醒", message: "請選擇飲料甜度,感謝配合", remind: .error)}
        guard tempTextField.text != "" else {return showRemindAlert(title: "提醒", message: "請選擇飲料溫度,感謝配合", remind: .error)}
        guard toppingTextField.text != "" else{return showRemindAlert(title: "提醒", message: "請選擇配料與否,感謝配合", remind: .error)}
        let uploadURL = URL(string: "https://api.airtable.com/v0/appEvFweIJ3Hd40r8/order")!
        let id = createID()
        let orderFields = Order.Records.Fields(ordererName: ordererNameTextField.text!, imageURL: itemDetail.image, drinksName: itemDetail.name, drinksTemperature: tempTextField.text!, drinksSugar: sugarTextField.text!, drinksTopping: toppingTextField.text!, remark: remarkTextField.text!, quantity: quantity, price: totalPrice, createdID: id)
        let orderRecords = Order.Records(fields: orderFields)
        let order = Order(records: [orderRecords])
        sendOutOrderAlert { _ in
            OrderController.shared.uploadOrder(url: uploadURL, data: order) { result in
                switch result{
                case .success(let result) :
                    DispatchQueue.main.async {
                        self.showRemindAlert(title: result, message: "感謝您的訂購", remind: .success)
                        OrderController.shared.order.orders.append(orderRecords)
                    }
                case .failure(_):
                    print("error")
                }
            }
        }
    }
    func showRemindAlert(title:String,message:String,remind:Remind){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "關閉", style: .default, handler: { ＿ in
            switch remind{
            case .error:
                alert.dismiss(animated: false, completion: nil)
            case .success:
                self.navigationController?.popViewController(animated: true)
            }
            
        }))
        present(alert, animated: true, completion: nil)
    }
    func sendOutOrderAlert(completion:@escaping(UIAlertAction)->()){
        let alert = UIAlertController(title: "發送確認", message: "訂購人:\(ordererNameTextField.text!)\n\(itemDetail.name),\(sugarTextField.text!)\(tempTextField.text!),\(toppingTextField.text!)\n共\(totalPrice)元", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    func createID()->String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmSS"
        return dateFormatter.string(from: now)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "(必填)"
        }else{
            return "其他"
        }
    }
}
