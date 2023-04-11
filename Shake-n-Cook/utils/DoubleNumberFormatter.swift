//
// Created by rémy barbosa on 26/03/2023.
//

import Foundation

class DoubleNumberFormatter: NumberFormatter {
    override init() {
        super.init()
        numberStyle = .decimal
        maximumFractionDigits = 2
        minimumFractionDigits = 0
        allowsFloats = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
