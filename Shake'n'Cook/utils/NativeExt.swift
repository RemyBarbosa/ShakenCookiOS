//
//  NativeExt.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 21/03/2023.
//

import Foundation

extension Array {
    func filterDuplicates<T: Hashable>(on keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
