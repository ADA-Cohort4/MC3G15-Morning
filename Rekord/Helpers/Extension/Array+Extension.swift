//
//  Array+Extension.swift
//  Diabestie
//
//  Created by Dhiky Aldwiansyah on 05/04/21.
//

import Foundation

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}
