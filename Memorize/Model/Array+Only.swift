//
//  Array+Only.swift
//  Memorize
//
//  Created by Gabriel Caron on 2021-02-20.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
