//
//  NewsVC+Extension.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/27.
//

import Foundation
import UIKit
import SafariServices

//collecitonCiew
private let collectionReusbleIdentifier = "bannerCell"
extension MenuItemViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImageName.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:collectionReusbleIdentifier , for: indexPath) as! bannerImageCollectionViewCell
        cell.bannerItemImageView.image = UIImage(named: bannerImageName[indexPath.row])
        return cell
    }
}
