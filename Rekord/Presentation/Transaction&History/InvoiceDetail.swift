//
//  InvoiceDetail.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 26/08/21.
//

import UIKit

class InvoiceDetail: UIViewController {

    @IBOutlet weak var invoiceImageView: UIImageView!
    
    var transaction: TransactionModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateImage()
        self.title = "TRX#\(transaction.idTransaction?.uppercased() ?? "")"
        navigationController?.navigationItem.leftBarButtonItem?.title = "Back"

        // Do any additional setup after loading the view.
    }
    
    func generateImage() {
        let newImageData = Data(base64Encoded: transaction.document!)
        if let newImageData = newImageData {
            self.invoiceImageView.image = UIImage(data: newImageData)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
