//
//  UIViewControllerExtension.swift
//  GolfPad-Test
//
//  Created by Иван Суслов on 13.04.2023.
//

import UIKit

extension UIViewController{
    
    func showToast (message: String, interval: Double, completion: (()->Void)? = nil) {
        let alert = UIAlertController.init (title: nil,
                                            message: message,
                                            preferredStyle: .alert)
        alert.view.backgroundColor = .systemGreen
        alert.view.alpha = 1
        alert.view.layer.cornerRadius = 15
        
        self.present (alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval) {
            alert.dismiss (animated: true, completion: nil)
            if let c = completion {
                c()
            }
        }
    }
}
