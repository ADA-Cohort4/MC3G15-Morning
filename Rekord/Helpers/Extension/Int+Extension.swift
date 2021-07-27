//
//  Int+Extension.swift
//  Diabestie
//
//  Created by Dhiky Aldwiansyah on 06/04/21.
//

import Foundation

extension Int {
    func roundingUp() -> Int {
        return Int(ceil(Double(self) / 100.0)) * 100
    }
}
