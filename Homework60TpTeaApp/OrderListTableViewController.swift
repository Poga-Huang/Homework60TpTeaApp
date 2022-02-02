//
//  OrderListTableViewController.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/30.
//

import UIKit
private let reusableIdentifier = "OrderItem"
private let segueIdentifier = "toEditOrder"

class OrderListTableViewController: UITableViewController {
    
    @IBOutlet weak var orderTotalLabel: UILabel!
    var orderCount:Int{
        get{
           return orderItems.count
        }
    }
    //接收下載資料
    var orderItems = [OrderList.Records](){
        didSet{
            DispatchQueue.main.async {
                self.orderTotalLabel.text = "共\(self.orderCount)筆訂單"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "navigationLogo"))
    }
    
    //畫面出現就下載，所以每次點開就會重新下載一次
    override func viewDidAppear(_ animated: Bool) {
        OrderController.shared.fetchOrderItem { result in
            switch result{
            case .success(let orderResponse):
                self.orderItems = orderResponse
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                print("error")
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! OrderItemTableViewCell
        
        configureCell(cell, forRowAt: indexPath)
        
        return cell
    }
    
   
    func configureCell(_ cell:OrderItemTableViewCell,forRowAt indexPath:IndexPath){
        let orderItemData = orderItems[indexPath.row].fields
        cell.sequenceImageView.image = UIImage(systemName: "\(indexPath.row+1).circle")
        cell.ordererNameLabel.text = orderItemData.ordererName
        cell.drinksNameLabel.text = orderItemData.drinksName
        cell.drinksContentLabel.text = "\(orderItemData.drinksSugar),\(orderItemData.drinksTemperature),\(orderItemData.drinksTopping) *\(orderItemData.quantity)"
        if orderItemData.remark == nil{
            cell.remarkLabel.text = "無"
        }else{
            cell.remarkLabel.text = orderItemData.remark
        }
        MenuItemController.shared.fetchItemImage(url: orderItemData.imageURL) { result in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    if indexPath == self.tableView.indexPath(for: cell){
                        cell.drinksCoverImageView.image = image
                        cell.loadingActivityIndicator.stopAnimating()
                    }
                }
            case .failure(_):
                print("error")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let orderItem = orderItems[indexPath.row]
            OrderController.shared.deleteOrderItem(orderID: orderItem.id) { result in
                switch result{
                case .success(let message):
                  print(message)
                    DispatchQueue.main.async {
                        self.orderItems.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    print("error")
                }
            }
        }
    }
}
