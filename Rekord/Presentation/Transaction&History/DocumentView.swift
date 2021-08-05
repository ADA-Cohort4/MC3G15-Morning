//
//  DocumentView.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit

class DocumentView: UIViewController{
    
    @IBOutlet weak var proofOfPayment: UIImageView!
    
    override func viewDidLoad() {
        proofOfPayment.image = UIImage.init(named: "receipt")
    }
}
