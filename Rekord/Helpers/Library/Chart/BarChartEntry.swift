//
//  BasicBarEntry.swift
//  Diabestie
//
//  Created by Dhiky Aldwiansyah on 05/04/21.
//

import Foundation
import CoreGraphics.CGGeometry
import UIKit

struct BarChartEntry {
    let origin: CGPoint
    let barWidth: CGFloat
    var barHeight: CGFloat
    let space: CGFloat
    let data: BarDataEntry
    
    var bottomTitleFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y + 10 + barHeight, width: barWidth + space, height: 22)
    }
    
    var textValueFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y - 30, width: barWidth + space, height: 22)
    }
    
    var barFrame: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: barWidth, height: barHeight)
    }
}

struct BarDataEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
    
    /// To be shown at the bottom of the bar
    let time: Float
}

struct BarChartThresholdDataEntry {
    let color: UIColor
    let value: Int
}

struct HorizontalLine {
    let segment: LineSegment
    let isDashed: Bool
    let width: CGFloat
    let value: CGFloat
    let text: String
}

struct ThresholdHorizontalLine {
    let segment: LineSegment
    let isDashed: Bool
    let width: CGFloat
    let threshold: Float
    let color : CGColor
}

struct VerticalLine {
    let segment: LineSegment
    let isDashed: Bool
    let width: CGFloat
}

struct LineSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
}
