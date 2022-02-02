//
//  LaunchScreenViewController.swift
//  Homework60TpTeaApp
//
//  Created by 黃柏嘉 on 2022/1/26.
//

import UIKit
private let segueIdentifier = "LaunchScreenOver"

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 0, options: .curveEaseIn, animations: {
            self.logoImageView.alpha = 1
        }, completion:{ _ in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        })
    }

}
