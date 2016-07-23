//
//  RPN.swift
//  Calculator
//
//  Created by Kanta Demizu on 5/9/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import Foundation

class RPNCalc {
    private var asRPN = [String]() // array after convertion to RPN
    
    var inputArray = [String]()
    var rpnString = "" // output string after convertion to RPN
    
    static func operatorPriority(oper: String) -> Int {
        switch oper {
        case "(":
            return 0
        case "+", "-":
            return 1
        case "*", "/":
            return 2
        case "^":
            return 3
        case ")":
            return 4
        default: // numbers
            return -1
        }
    }
    
    init(_ input: [String]) {
        self.inputArray = input
        self.toRPN()
    }
    
    func toRPN() {
        var stack = [String]()
        var output = [String]()
        for item in inputArray {
            switch RPNCalc.operatorPriority(item) {
            case -1: output.append(item)
            case 0: stack.append(item)
            case 4:
                while let last = stack.last {
                    if RPNCalc.operatorPriority(last) != 0 {
                        output.append(stack.removeLast())
                    } else {
                        stack.removeLast()
                    }
                }
            default:
                while let last = stack.last {
                    if RPNCalc.operatorPriority(last) >= RPNCalc.operatorPriority(item) {
                        output.append(stack.removeLast())
                    } else {
                        break
                    }
                }
                stack.append(item)
            }
        }
        while stack.last != nil {
            output.append(stack.removeLast())
        }
        self.asRPN = output
        self.rpnString = output.joinWithSeparator(" ")
    }
}