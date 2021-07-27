//
//  UIColor+Extension.swift
//  Diabestie
//
//  Created by Diabestie Team.
//  swiftlint:disable all

import UIKit

// MARK: - Colors Asset

extension UIColor {

    static let blueAccent = UIColor.color(named: "customAccentColorLight")
    static let disabledDark = UIColor.color(named: "disabledDark")
    static let expese = UIColor.color(named: "expese")
    static let fill4Quarternary = UIColor.color(named: "fill4Quarternary")
    static let fillOpaque = UIColor.color(named: "fillOpaque")
    static let iOsWhite = UIColor.color(named: "iOsSystemBackgroundsLightSystemBackgroundPrimary")
    static let iOsWhiteBlack = UIColor.color(named: "iOsSystemFillsLight3TertiaryFillColor")
    static let iOsWhiteGrey = UIColor.color(named: "iOsSystemSeparatorsLightSeparatorColor")
    static let greenBackground = UIColor.color(named: "green_background")
    static let obsidian = UIColor.color(named: "obsidian")
    static let lightPeriwinkle = UIColor.color(named: "light_periwinkle")
    static let primary1 = UIColor.color(named: "primary1")
    static let primary2 = UIColor.color(named: "primary2")
    static let secondary = UIColor.color(named: "secondary")

    private static func color(named: String) -> UIColor {
        return UIColor(named: named)!
    }

}

