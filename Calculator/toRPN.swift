//
//  toRPN.swift
//  Calculator
//
//  Created by Kanta Demizu on 5/11/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import Foundation
class convertRPN  {
    let opa = [
        "^": (prec: 4, rAssoc: true),
        "×": (prec: 3, rAssoc: false),
        "÷": (prec: 3, rAssoc: false),
        "+": (prec: 2, rAssoc: false),
        "-": (prec: 2, rAssoc: false),
        ]
    
    func rpn(_ tokens: [String]) -> [String] {
        var rpn : [String] = []
        var stack : [String] = [] // holds operators and left parenthesis
        
        for tok in tokens {
            switch tok {
            case "(":
                stack += [tok] // push "(" to stack
            case ")":
                while !stack.isEmpty {
                    let op = stack.removeLast() // pop item from stack
                    if op == "(" {
                        break // discard "("
                    } else {
                        rpn += [op] // add operator to result
                    }
                }
            default:
                if let o1 = opa[tok] { // token is an operator?
                    for op in stack.reversed() {
                        if let o2 = opa[op] {
                            if !(o1.prec > o2.prec || (o1.prec == o2.prec && o1.rAssoc)) {
                                // top item is an operator that needs to come off
                                rpn += [stack.removeLast()] // pop and add it to the result
                                continue
                            }
                        }
                        break
                    }
                    
                    stack += [tok] // push operator (the new one) to stack
                } else { // token is not an operator
                    rpn += [tok] // add operand to result
                }
            }
        }
        
        return rpn + stack.reversed()
    }
    
    func parseInfix(_ e: String) -> String {
        let tokens = e.split{ $0 == " " }.map(String.init)
        print("CalArrayIs\'\(tokens)\'")
        if tokens.last == "+" || tokens.last == "-" || tokens.last == "×" || tokens.last == "÷" {
            return ""
        }
        else {
            return rpn(tokens).joined(separator: " ")
        }
    }
}
