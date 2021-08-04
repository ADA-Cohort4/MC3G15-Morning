//
//  CommonFunction.swift
//  Kantongku
//
//  Created by Julius Cesario on 03/05/21.
//

import Foundation
import UIKit

class CommonFunction {

    static let shared = CommonFunction()

    func showAlertWithCompletion(_ viewController: UIViewController, title: String, message msg: String, completionBlock: @escaping () -> Void,failureBlock: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK!", style: .default, handler: { action in
            
            completionBlock()
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            failureBlock()
            
        })
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func addShadow(view : UIView){//buat nambahin shadow ke element
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
