//
//  NumbersOnlyViewModifier.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/29/23.
//

import SwiftUI
import Combine

struct NumbersOnlyViewModifier: ViewModifier {
    
    @Binding var text: String
    var includeDecimal: Bool
    
    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? .decimalPad : .numberPad)
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                let decimalSeperator: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                    numbers += decimalSeperator
                }
                
                if newValue.components(separatedBy: decimalSeperator).count-1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter { numbers.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = true) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}
