//
//  DocumentView.swift
//  Rekord
//
//  Created by Julius Cesario on 27/07/21.
//

import UIKit

class DocumentView: UIViewController{
    
    @IBOutlet weak var proofOfPayment: UIImageView!
    var documentFile: String = ""
    var transactionNumber: String = ""
    
    override func viewDidLoad() {
        proofOfPayment.image = UIImage.init(named: "receipt")
        navigationItem.title = transactionNumber 
        generateImage()
    }
    
    func generateImage() {
        print("image")
        print(documentFile)
        let newImageData = Data(base64Encoded: documentFile)
        if let newImageData = newImageData {
            self.proofOfPayment.image = UIImage(data: newImageData)
        }
    }
}
