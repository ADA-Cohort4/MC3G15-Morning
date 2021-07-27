//
//  BarChartPresenter.swift
//  Diabestie
//
//  Created by Dhiky Aldwiansyah on 05/04/21.
//

import Foundation
import CoreGraphics.CGGeometry
import UIKit

class BasicBarChartPresenter {
    
    let barWidth: CGFloat
    let space: CGFloat
    var highestValue: Int = 0
    var userThreshold = [BarChartThresholdDataEntry]()
    let bottomTitleText: [String]
    private let bottomSpace: CGFloat = 40.0
    private let topSpace: CGFloat = 40.0
    
    var dataEntries: [BarDataEntry] = []
    
    init(barWidth: CGFloat = 10, space: CGFloat = 20, bottomTitleText: [String] = [""]) {
        self.barWidth = barWidth
        self.space = space
        self.bottomTitleText = bottomTitleText
    }
    
    func computeContentWidth() -> CGFloat {
        return (barWidth + space) * CGFloat(dataEntries.count) + space
    }
    
    func computeBarEntries(viewHeight: CGFloat, viewWidth: CGFloat) -> [BarChartEntry] {
        var result: [BarChartEntry] = []
        
        for (_, entry) in dataEntries.enumerated() {
            let entryHeight = CGFloat(Float(entry.height) / Float(highestValue)) * (viewHeight - bottomSpace)
            let yPosition = viewHeight - bottomSpace - entryHeight
            
            //Known issues
            //Will break in landscape mode / different size, need a further checkup!
            let origin = CGPoint(x: CGFloat(entry.time * 14), y: yPosition)
            
            let barEntry = BarChartEntry(origin: origin, barWidth: barWidth, barHeight: entryHeight, space: space, data: entry)
            
            result.append(barEntry)
        }
        return result
    }
    
    func computeLineThreshold(viewHeight: CGFloat, viewWidth: CGFloat)  -> [ThresholdHorizontalLine] {
        var result: [ThresholdHorizontalLine] = []
        
        var horizontalLineInfos = [(value: CGFloat(0.0), isDashed: true, threshold: 0, color: UIColor.red.cgColor)]
        horizontalLineInfos.removeAll()
        
        userThreshold.forEach{ value in
            horizontalLineInfos.append((value:  CGFloat(0.0), isDashed: true, threshold: value.value, color: value.color.cgColor))
        }
        
        for lineInfo in horizontalLineInfos {
            let height: Float = Float(lineInfo.threshold) / Float(self.highestValue)
            
            let yPosition = viewHeight - bottomSpace -  CGFloat(height) * (viewHeight - bottomSpace)
            
            let length = viewWidth - 36
            let lineSegment = LineSegment(
                startPoint: CGPoint(x: 0, y: yPosition),
                endPoint: CGPoint(x: length, y: yPosition)
            )
            let line = ThresholdHorizontalLine(
                segment: lineSegment,
                isDashed: lineInfo.isDashed,
                width: 0.5,
                threshold: Float(lineInfo.threshold),
                color: lineInfo.color)
            result.append(line)
        }
        
        return result
    }
    
    func computeHorizontalLines(viewHeight: CGFloat, viewWidth: CGFloat) -> [HorizontalLine] {
        var result: [HorizontalLine] = []
        
        let horizontalLineInfos = [
            (value: CGFloat(0.0), isDashed: false, text: "0"),
            (value: CGFloat(0.5), isDashed: false, text: "\(highestValue/2)"),
            (value: CGFloat(1.0), isDashed: false, text: "\(highestValue)")
        ]
        
        for lineInfo in horizontalLineInfos {
            let yPosition = viewHeight - bottomSpace -  lineInfo.value * (viewHeight - bottomSpace)
            
            let length = viewWidth - 36
            let lineSegment = LineSegment(
                startPoint: CGPoint(x: 0, y: yPosition),
                endPoint: CGPoint(x: length, y: yPosition)
            )
            let line = HorizontalLine(
                segment: lineSegment,
                isDashed: lineInfo.isDashed,
                width: 0.5,
                value: lineInfo.value,
                text: lineInfo.text)
            result.append(line)
        }
        
        return result
    }
    
    func computeVerticalLines(viewHeight: CGFloat, viewWidth: CGFloat) -> [VerticalLine] {
        var result: [VerticalLine] = []
        
        let verticalLineInfos = [
            (value: CGFloat(0.0), isDashed: false),
            (value: CGFloat(0.5), isDashed: true),
            (value: CGFloat(1.0), isDashed: true),
            (value: CGFloat(1.5), isDashed: true),
            (value: CGFloat(2.0), isDashed: false)
        ]
        
        for (index, lineInfo) in verticalLineInfos.enumerated() {
            let xPos = CGFloat(index) * (viewHeight/3)
            
            let lineSegment = LineSegment(
                startPoint: CGPoint(x: xPos, y: viewHeight),
                endPoint: CGPoint(x: xPos, y: 0)
            )
            let line = VerticalLine(
                segment: lineSegment,
                isDashed: lineInfo.isDashed,
                width: 0.5)
            result.append(line)
        }
        
        return result
    }
}
