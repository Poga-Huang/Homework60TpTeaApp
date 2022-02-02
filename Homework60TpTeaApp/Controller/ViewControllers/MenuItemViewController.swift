//
//  NewsViewController.swift
//  Homework61TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/27.
//

import UIKit
import SafariServices


class MenuItemViewController: UIViewController {
    
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    
    private var timer:Timer?
    private var bannerIndex = 0
    internal let bannerImageName = ["1","2","3","4","1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //titleView
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "navigationLogo"))

       //collectionView
        setUpFlowLayout()
        bannerPageControl.numberOfPages = bannerImageName.count-1
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(autoScrollBanner), userInfo: nil, repeats: true)
    }
    
    func setUpFlowLayout(){
        let flowLayout = bannerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = .zero
        flowLayout.estimatedItemSize = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: bannerCollectionView.bounds.width, height: bannerCollectionView.bounds.height)
    }
    //自動輪播的banner
    @objc func autoScrollBanner(){
        var indexPath:IndexPath
        bannerIndex += 1
        if bannerIndex < bannerImageName.count{
            indexPath = IndexPath(item: bannerIndex, section: 0)
            bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if bannerIndex < bannerImageName.count-1{
                bannerPageControl.currentPage = bannerIndex
            }else{
                bannerPageControl.currentPage = 0
            }
        }else{
            bannerIndex = 0
            indexPath = IndexPath(item: bannerIndex, section: 0)
            bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            autoScrollBanner()
        }
    }
    
    
}

