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
    static var picker : [String] = ["Start Date", "End Date"]
    var viewMode = ""
    static var dates : [Date] = [Date(), Date()] // 0 = start, 1 = end
    var cellIndex : [Int] = []
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
        
           
            optionsTableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
        
   
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        filterTitle.text = "Select your Partner"
        addSubview(baseView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewMode != "date"{
            return cellData.count
        } else{
            return FilterView.picker.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewMode != "date"{
            let cell = optionsTableView.dequeueReusableCell(withIdentifier: "NormalOptViewCell") as! NormalOptViewCell
            cell.labelName.text = cellData[indexPath.row]
            return cell
        } else{
            let cell = optionsTableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
            
            cell.dateTitle.text = FilterView.picker[indexPath.row]
           // cellIndex.append(indexPath.row)
            cell.pickerCell.addTarget(self, action: #selector(self.onPickerDone), for: .editingDidEnd)
            cellIndex.append(cell.tag)
            
            return cell
        }
    
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewMode != "date"{
            selectedOption = cellData[indexPath.row]
        }
        
    }
    @IBAction func onPickerDone(){
        
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
