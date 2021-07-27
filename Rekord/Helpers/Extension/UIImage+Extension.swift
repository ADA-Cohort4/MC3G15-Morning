//
//
//  UIImage+Extension.swift
//  Diabestie
//
//  Created by Diabestie Team.
//  swiftlint:disable all

import UIKit

// MARK: - Images Asset

extension UIImage {

    static let food = UIImage.image(named: "food")
    static let main = UIImage.image(named: "main")
    static let placeholderPerson = UIImage.image(named: "placeholder_person")
    static let transparentPixel = UIImage.image(named: "transparent_pixel")

    private static func image(named: String) -> UIImage {
        return UIImage(named: named)!
    }
}
