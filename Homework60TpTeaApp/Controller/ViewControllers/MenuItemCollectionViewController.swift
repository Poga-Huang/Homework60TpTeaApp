//
//  MenuItemCollectionViewController.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/28.
//

import UIKit

private let reuseIdentifier = "menuItemCell"
private let segueIdentifier = "showOrder"

class MenuItemCollectionViewController: UICollectionViewController {
    
    //接收下載的資料
    static var menuItem:MenuItem?
    
    
    //存取要傳送到訂購畫面的資料
    var passItemDetail:ItemDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //下載資料
        MenuItemController.shared.fetchMenuItem { result in
            switch result{
            case .success(let menuItemResponse):
                MenuItemCollectionViewController.menuItem = menuItemResponse
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(_):
                print("error")
            }
        }
        
    }
    
    @IBSegueAction func passItemDetail(_ coder: NSCoder) -> OrderTableViewController? {
        guard let passItemDetail = passItemDetail else {return nil}
        return OrderTableViewController(coder: coder, itemDetail: passItemDetail)
    }
    
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let menuItem = MenuItemCollectionViewController.menuItem else {
            return 1
        }
        return menuItem.records.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MenuItemCollectionViewCell
        if MenuItemCollectionViewController.menuItem != nil{
          configureCell(cell, forItemAt: indexPath)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = MenuItemCollectionViewController.menuItem?.records[indexPath.item].fields else{return}
        passItemDetail = ItemDetail(name: data.name, image:data.image[0].url , price: data.price, category: data.category, hot: data.hot, noIceFree: data.noIceFree)
        
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    func configureCell(_ cell:MenuItemCollectionViewCell,forItemAt indexPath:IndexPath){
        let data = MenuItemCollectionViewController.menuItem!.records[indexPath.item].fields
        cell.loadingActivityIndicator.stopAnimating()
        cell.isUserInteractionEnabled = true
        cell.menuItemNameLabel.text = "-\(data.name)-"
        cell.itemPriceLabel.text = "$\(data.price)"
        MenuItemController.shared.fetchItemImage(url: data.image[0].url) { result in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    if indexPath == self.collectionView.indexPath(for: cell){
                        cell.menuItemImageView.image = image
                    }
                }
            case .failure(_):
                print("error")
            }
        }
    }

}
