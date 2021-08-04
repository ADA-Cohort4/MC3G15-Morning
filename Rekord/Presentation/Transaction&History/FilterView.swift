//
//  FilterView.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 03/08/21.
//

import UIKit

class FilterView : UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var filterTitle: UILabel!
    var cellData : [String] = []
    var selectedOption : String = ""
    
    var viewMode = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
     private func commonInit(){
        Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)
        optionsTableView.register(UINib(nibName: "NormalOptViewCell", bundle: nil), forCellReuseIdentifier: "NormalOptViewCell")
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        filterTitle.text = "Select your Partner"
        addSubview(baseView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "NormalOptViewCell") as! NormalOptViewCell
        cell.labelName.text = cellData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = cellData[indexPath.row]
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
