//
//  BarChart.swift
//  Diabestie
//
//  Created by Dhiky Aldwiansyah on 05/04/21.
//

import Foundation
import UIKit

class BarChart: UIView {
    
    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    private var animated = false
    private var showThresholdData = false
    private let presenter = BasicBarChartPresenter(barWidth: 10, space: 20, bottomTitleText: ["00", "06", "12","18"])
    private var userHighestThreshold = [80,120,230].max() ?? 0
    
    private var barEntries: [BarChartEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
            mainLayer.frame = CGRect(x: 16, y: 0, width: self.frame.size.width, height: scrollView.contentSize.height)
            
            showHorizontalLines()
            showVerticalLines()
            
            if showThresholdData {
                showThresholdLines()
            }
            for (index, entry) in barEntries.enumerated() {
                showEntry(index: index, entry: entry, animated: animated, oldEntry: oldValue.safeValue(at: index))
            }
            
        }
    }
    
    func initiateThreshold(thresholdDataEntry: [BarChartThresholdDataEntry]) {
        self.showThresholdData = true
        self.userHighestThreshold = thresholdDataEntry.map {$0.value}.max() ?? 0
        self.presenter.userThreshold = thresholdDataEntry
    }
    
    func updateDataEntries(dataEntries: [BarDataEntry], animated: Bool) {
        self.setupHighestValue(dataEntries: dataEntries)
        self.animated = animated
        self.presenter.dataEntries = dataEntries
        self.barEntries = self.presenter.computeBarEntries(viewHeight: self.frame.height, viewWidth: self.frame.width)
    }
    
    func setupHighestValue(dataEntries: [BarDataEntry]){
        let userInputHighestValue = Int(dataEntries.max { $0.height < $1.height }?.height ?? 0)
        
        if userHighestThreshold > userInputHighestValue {
            self.presenter.highestValue = userHighestThreshold.roundingUp()
        } else {
            self.presenter.highestValue = userInputHighestValue.roundingUp()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        scrollView.layer.addSublayer(mainLayer)
        self.layer.addSublayer(bottomTextLayer())
        self.addSubview(scrollView)
        
        scrollView.scrollsToTop = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    private func bottomTextLayer() -> CALayer{
        let bottomTextLayer: CALayer = CALayer()
        for (index, data) in self.presenter.bottomTitleText.enumerated() {
            let xPos = CGFloat(index) * (self.frame.height/3)
            bottomTextLayer.addTextLayer(frame: CGRect.init(x: xPos + 16, y: 220, width: 20, height: 20), color: UIColor.systemBlue.cgColor, fontSize: 12, text: data, animated: true, oldFrame: CGRect.init())
        }
        
        return bottomTextLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataEntries(dataEntries: presenter.dataEntries, animated: false)
    }
    
    private func showEntry(index: Int, entry: BarChartEntry, animated: Bool, oldEntry: BarChartEntry?) {
        
        let cgColor = entry.data.color.cgColor
        
        // Show the main bar
        mainLayer.addRectangleLayer(frame: entry.barFrame, color: cgColor, animated: animated, oldFrame: oldEntry?.barFrame)
        
        // Show an Int value above the bar
        //        mainLayer.addTextLayer(frame: entry.textValueFrame, color: cgColor, fontSize: 14, text: entry.data.textValue, animated: animated, oldFrame: oldEntry?.textValueFrame)
        
        // Show a title below the bar
        //        mainLayer.addTextLayer(frame: entry.bottomTitleFrame, color: cgColor, fontSize: 14, text: "\(Int(entry.data.time))", animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
        
        // Show a title on the right of the bar
        //        mainLayer.addTextLayer(frame: entry.bottomTitleFrame, color: cgColor, fontSize: 14, text: entry.data.title, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
    }
    
    private func showHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let lines = presenter.computeHorizontalLines(viewHeight: self.frame.height, viewWidth: self.frame.width - CGFloat(20))
        lines.forEach { (line) in
            mainLayer.addLineLayer(lineSegment: line.segment, color: UIColor.systemBlue.cgColor, width: line.width, isDashed: false, animated: false, oldSegment: nil)
        }
        
        showTextBesideHorizontalLine()
    }
    
    private func showThresholdLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let lines = presenter.computeLineThreshold(viewHeight: self.frame.height, viewWidth: self.frame.width - CGFloat(20))
        lines.forEach { (line) in
            mainLayer.addLineLayer(lineSegment: line.segment, color: line.color, width: line.width, isDashed: true, animated: false, oldSegment: nil)
        }
        
        showTextBesideThresholdLine()
    }
    
    private func showTextBesideThresholdLine(){
        
        let lines = presenter.computeLineThreshold(viewHeight: self.frame.height, viewWidth: self.frame.width - CGFloat(20))
        
        lines.forEach { (line) in
            
            let height: Float = Float(line.threshold) / Float(self.presenter.highestValue)
            
            let yPosition = self.frame.height - 40 -  CGFloat(height) * (self.frame.height - 40)
            
            mainLayer.addTextLayer(frame: CGRect.init(x: 2, y: yPosition + 4 , width: 50, height: 20), color: line.color, fontSize: 12, text: "\(String.init(format:"%.0f", line.threshold))", animated: true, oldFrame: CGRect.init())
        }
        
    }
    
    private func showTextBesideHorizontalLine(){
        
        let lines = presenter.computeHorizontalLines(viewHeight: self.frame.height, viewWidth: self.frame.width - CGFloat(20))

        lines.forEach { (line) in
            
            let yPosition = self.frame.height - 40 -  line.value * (self.frame.height - 40 - 10)
            
            mainLayer.addTextLayer(frame: CGRect.init(x: self.frame.width - 65, y: yPosition - 10, width: 50, height: 20), color: UIColor.systemBlue.cgColor, fontSize: 12, text: line.text, animated: true, oldFrame: CGRect.init())
        }
    }
    
    private func showVerticalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let lines = presenter.computeVerticalLines(viewHeight: self.frame.height, viewWidth: self.frame.width)
        lines.forEach { (line) in
            mainLayer.addLineLayer(lineSegment: line.segment, color: UIColor.systemBlue.cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
        }
    }
}
