//
//  ViewController.swift
//  Calculator
//
//  Created by Owner on 3/1/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NumView.numberOfLines=3
        NumView.adjustsFontSizeToFitWidth = true
        Calculation.adjustsFontSizeToFitWidth = true
        Calculation.numberOfLines = 4
        Calculation.minimumScaleFactor = 0.8
        NumView.minimumScaleFactor = 0.8
        NumView.sizeToFit()
        fontSizeofUIButton.titleLabel?.adjustsFontSizeToFitWidth=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //ヘルプ画面
    /*
    @IBAction func aboutButton(sender: UIBarButtonItem) {
        self.canDisplayBannerAds = true
    }
    */
    @IBOutlet weak var NumView: UILabel!
    @IBOutlet weak var Calculation: UILabel!
    var Num:String="0",Symbol:String = "Null",NumA:Int = 0,NumB:Double = 0,NumC:Double = 0,Ans:Double = 0.0,AnsCal:String="",BoolSym:Bool = false,CalText:String = "",Cal:String="",appendLastNumber:String="",endPoint:Int=0
    let rpnconv=convertRPN(),fontSizeofUIButton = UIButton(),CalSym = ["+","-","×","÷"], predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
    let generator=UIImpactFeedbackGenerator(style: .heavy)
    
    /*入力*/
    
    //数字入力
    func inputNumber(){
        let pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
        if (NumView.text=="0"||NumView.text=="Error"){
            NumView.text=""
        }
        if pmArray.last!.count > 20 {
        }
            
        else if pmArray.last!.count <= 20 {
            NumView.text = (NumView.text)! + String(format: "%d",NumA)
        }
    }
    //計算記号入力
    func inputSymbol(){
        print(NumView.text!)
        if ((Calculation.text?.range(of: AnsCal)) != nil) {
            NumView.text = (NumView.text)! + " "
            NumView.text = (NumView.text)! + "\(Symbol)"
            NumView.text = (NumView.text)! + " "
        }
        else{
            NumView.text = (NumView.text)! + " "
            NumView.text = (NumView.text)! + "\(Symbol)"
            NumView.text = (NumView.text)! + " "
        }
    }
    
    //開きカッコ
    func pressParenthesisStart() {
        BoolSym=(NumView.text?.hasSuffix("\(Symbol)"))!
        print(BoolSym)
        if NumView.text=="0" {
            NumView.text = " ( "
            
        }
        if NumView.text?.hasSuffix(" ( ") == true {
        }
        else if BoolSym == true {
            NumView.text = (NumView.text)! + " ( "
            BoolSym=true
        }
    }
    
    //閉じカッコ
    func pressParenthesisEnd() {
        var FromParenthesisSt = NumView.text?.indexOf("( ")
        FromParenthesisSt =  NumView.text?.index(after: FromParenthesisSt!)
        if NumView.text == "0" {
        }
        else if NumView.text?.hasSuffix(" ) ") == true {
        }
        else if FromParenthesisSt != nil {
            CalText = String(NumView.text!.suffix(from: FromParenthesisSt!))
            print("CalTextIs\(CalText)")
            BoolSym = (NumView.text?.hasSuffix("\(CalText)"))!
            print("BoolSymIs\(BoolSym)")
        }
        if BoolSym == true{
            NumView.text = (NumView.text)! + " ) "
            BoolSym = false
        }
    }
    
    //イコール動作
    func pressEqual() {
        if (Calculation.text=="Welcome."&&Calculation.text=="0") {
            Calculation.text="0"
        }
        if Calculation.text?.hasSuffix("Error") == true || (NumView.text?.hasSuffix("nan"))! {
            Calculation.text = (NumView.text)! + " = Error"
            NumView.text = "Error"
        }
        else {
            if ((NumView.text! + "%").toBool() == true) {
                let pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
                CalText = NumView.text!
                endPoint = (NumView.text?.utf16.count)!-(pmArray.last?.utf16.count)!
                NumView.text=NumView.text?.substring(to: NumView.text!.index(NumView.text!.startIndex, offsetBy: endPoint))
                NumView.text=(NumView.text)! + String(format: "%g",Double(pmArray.first!)!*Double(pmArray.last!)!*0.01)
                
            }
            print(NumView.text!)
            CalText = NumView.text!
            print("CalTextIs \'\(CalText)\'")
            Cal=rpnconv.parseInfix(CalText)
            print("CalIs \'\(Cal)\'")
            if Cal == "" {
            }
            else {
                if RPNCalc(Cal)=="+∞" {
                    NumView.text = "Error"
                    Calculation.text=(CalText + " = ") + "Error"
                }
                else {
                    let Ans:Double = Double(RPNCalc(Cal))!
                    NumView.text = String(Ans)
                    if ((NumView.text?.hasPrefix(".0")) != nil) {
                        NumView.text = RPNCalc(Cal)
                        print(NumView.text!)
                        Calculation.text=(CalText + " = ") + RPNCalc(Cal)
                    }
                    else {
                        print(NumView.text!)
                        Calculation.text=(CalText + " = ") + String(Ans)
                    }
                }
            }
            AnsCal=Calculation.text!
        }
    }
    
    //マイナスつけたり消したり
    func pressMinus() {
        var pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
        print("pmArrayIs\(pmArray)")
        if predicate.evaluate(with: pmArray.last)==false {
            if (pmArray.last?.range(of: "-") != nil) {
                let range = NumView.text?.range(of: "\(String(describing: pmArray.last))")
                NumView.text = NumView.text?.replacingOccurrences(of: "-", with: "", range:range )
            }
        }
        else if (pmArray.last?.range(of: "-") != nil) {
            let range = NumView.text?.range(of: "\(String(describing: pmArray.last))")
            NumView.text = NumView.text?.replacingOccurrences(of: "-", with: "", range:range )
        }
        else {
            endPoint = (NumView.text?.utf16.count)!-(pmArray.last?.utf16.count)!
            NumView.text=NumView.text?.substring(to: NumView.text!.index(NumView.text!.startIndex, offsetBy: endPoint))
            let appendLastNumber = "-" + pmArray.last! + ""
            NumView.text = (NumView.text)! + appendLastNumber
        }
        pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
        print("pmArrayAfterMinusIs\(pmArray)")
    }
    
    //1文字消去
    func deleteLastNumber()  {
        if NumView.text! != "" {
            if NumView.text?.utf16.count == 1 || NumView.text=="("{
                NumView.text! = "0"
            }
            else   {
                if NumView.text?.last==" " {
                    endPoint = (NumView.text?.utf16.count)!-3
                    NumView.text=NumView.text?.substring(to: NumView.text!.index(NumView.text!.startIndex, offsetBy: endPoint))
                }
                else {
                    endPoint = (NumView.text?.utf16.count)!-1
                    NumView.text=NumView.text?.substring(to: NumView.text!.index(NumView.text!.startIndex, offsetBy: endPoint))
                }
            }
        }
    }
    
    //パーセント計算
    func pressPercent() {
        var pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
        print("pmArrayIs\(pmArray)")
        if pmArray.last == Symbol || pmArray.count==1{
        }
        else{
            endPoint = (NumView.text?.utf16.count)!-(pmArray.last?.utf16.count)!
            NumView.text=NumView.text?.substring(to: NumView.text!.index(NumView.text!.startIndex, offsetBy: endPoint))
            let lastArray=pmArray.last
            if NumView.text?.range(of: " ) ") != nil {
                let startArrPoint:Int = pmArray.index(of: "(")!+1
                print(startArrPoint)
                let endArrPoint:Int = pmArray.index(of: ")")!
                print(endArrPoint)
                let calArray = pmArray[startArrPoint..<endArrPoint]
                print(calArray)
                let cal:String = calArray.joined(separator: " ")
                let perCal=rpnconv.parseInfix(cal)
                let perAns=RPNCalc(perCal)
                print(perCal)
                print(perAns)
                NumView.text=(NumView.text)! + String(format: "%g",Double(perAns)!*Double(lastArray!)!*0.01)
            }
            else{
                pmArray.removeLast()
                pmArray.removeLast()
                NumView.text=(NumView.text)! + String(format: "%g",Double(pmArray.last!)!*Double(lastArray!)!*0.01)
            }
        }
    }
    
    //計算
    func RPNCalc(_ input:String) -> String {
        let strs = input.components(separatedBy: " ")
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 20
        var numberStack:[Double] = []
        var result: String? = nil
        for one in strs {
            var number = formatter.number(from: one)?.doubleValue
            print("NumberIs \(String(describing: number))")
            if (nil != number) {
                numberStack.append(number!)
                continue
            }
            if (numberStack.count < 2) {
                print("CountIs \(numberStack.count)")
                result = "Invalid statement! Too few Operand"
                break
            }
            if (one == "+") {
                number = numberStack.popLast()
                number! = numberStack.popLast()! + number!
                numberStack.append(number!)
                continue
            }
            if (one == "-") {
                number = numberStack.popLast()
                number! = numberStack.popLast()! - number!
                numberStack.append(number!)
                continue
            }
            if (one == "×") {
                number = numberStack.popLast()
                number! = numberStack.popLast()! * number!
                numberStack.append(number!)
                continue
            }
            if (one == "÷") {
                number = numberStack.popLast()
                number! = numberStack.popLast()! / number!
                numberStack.append(number!)
                continue
            }
        }
        
        if (nil == result) {
            if (1 != numberStack.count) {
                result = "Invalid statement! Too many Operand"
            } else {
                result = formatter.string(from: NSNumber(value:numberStack[0]))
            }
        }
        return result!
    }
    
    //タップ時の効果音
    func tapSound(_ soundName:String){
        var soundIdRing:SystemSoundID = 0
        let soundPath = URL(fileURLWithPath: "/System/Library/Audio/UISounds/\(soundName)")
        AudioServicesCreateSystemSoundID(soundPath as CFURL, &soundIdRing)
        AudioServicesPlaySystemSound(soundIdRing)
    }
    
    //キャンセル
    func pressCancel(){
        Num = "0"
        NumA = 0
        NumB = 0
        NumC = 0
        Ans=00
        Symbol = ""
        NumView.text="0"
        Calculation.text="Welcome."
    }
    
    //小数点
    func pressDecimal(){
        if (NumView.text=="Error"){
            NumView.text="0"
        }
        if NumView.text?.range(of: ".") == nil {
            NumView.text = (NumView.text)! + "."
        }
    }
    
    
    /*ボタン動作*/
    
    @IBAction func Button00(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        if NumView.text != "0" {
            NumA=00
            let pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
            if pmArray.last!.count <= 20 {
                NumView.text = (NumView.text)! + "00"
            }
        }
    }
    @IBAction func ButtonRoot(_ sender: UIButton) {
        tapSound("key_press_modifier.caf")
        let pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
        print(pmArray)
        if pmArray.last==Symbol {
            let alert:UIAlertController=UIAlertController(title: "Information", message: " √x ボタンは計算結果のみ使用できます", preferredStyle: UIAlertController.Style.alert)
            let defaultAction:UIAlertAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        else {
            CalText = NumView.text!
            Cal = RPNCalc(rpnconv.parseInfix(NumView.text!))
            print("Cal=\(Cal)")
            Calculation.text = "√\(CalText) = \(String(format:"%.5g",sqrt(Double(Cal)!)))"
            NumView.text = String(format:"%.5g",sqrt(Double(Cal)!))
            AnsCal = Calculation.text!
        }
    }
    @IBAction func ButtonDecimal(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        pressDecimal()
    }
    @IBAction func ButtonDelete(_ sender: UIButton) {
        tapSound("key_press_delete.caf")
        generator.prepare()
        generator.impactOccurred()
        deleteLastNumber()
    }
    @IBAction func ButtonCancel(_ sender: UIButton) {
        tapSound("key_press_delete.caf")
        generator.prepare()
        generator.impactOccurred()
        pressCancel()
    }
    @IBAction func Button0(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=0
        inputNumber()
    }
    @IBAction func Button1(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=1
        inputNumber()
    }
    @IBAction func Button2(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=2
        inputNumber()
    }
    @IBAction func Button3(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=3
        inputNumber()
    }
    @IBAction func Button4(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=4
        inputNumber()
    }
    @IBAction func Button5(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=5
        inputNumber()
    }
    @IBAction func Button6(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=6
        inputNumber()
    }
    @IBAction func Button7(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=7
        inputNumber()
    }
    @IBAction func Button8(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=8
        inputNumber()
    }
    @IBAction func Button9(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        NumA=9
        inputNumber()
    }
    @IBAction func ButtonPlus(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        print(NumView.text?.hasSuffix("\(Symbol) ") as Any)
        if (NumView.text?.hasSuffix("\(Symbol) ")) == false {
            Symbol="+"
            inputSymbol()
        }
    }
    @IBAction func ButtonMinus(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        if NumView.text != "0" && NumView.text?.hasSuffix("\(Symbol) ") == false {
            Symbol="-"
            inputSymbol()
        }
    }
    @IBAction func ButtonCross(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        print(NumView.text?.hasSuffix("\(Symbol) ") as Any)
        if (NumView.text?.hasSuffix("\(Symbol) ")) == false {
            Symbol="×"
            inputSymbol()
        }
    }
    @IBAction func ButtonSlash(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        print(NumView.text?.hasSuffix("\(Symbol) ") as Any)
        if (NumView.text?.hasSuffix("\(Symbol) ")) == false {
            Symbol="÷"
            inputSymbol()
        }
    }
    @IBAction func ButtonParenthesisSt(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        pressParenthesisStart()
    }
    @IBAction func ButtonParenthesisEn(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        pressParenthesisEnd()
        let pmArray = NumView.text!.split{ $0 == " " }.map(String.init)
        BoolSym=(pmArray.last==Symbol)
        print(BoolSym)
        if NumView.text=="0" {
            NumView.text = " ( "
        }
        if NumView.text?.hasSuffix(" ( ") == true {
        }
        if BoolSym == true {
            NumView.text = (NumView.text)! + " ( "
            BoolSym=true
        }
    }
    @IBAction func ButtonPercent(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        pressPercent()
    }
    @IBAction func ButtonPlusMinus(_ sender: UIButton) {
        tapSound("key_press_click.caf")
        generator.prepare()
        generator.impactOccurred()
        pressMinus()
    }
    @IBAction func ButtonEqual(_ sender: UIButton) {
        tapSound("key_press_modifier.caf")
        generator.prepare()
        generator.impactOccurred()
        pressEqual()
    }
   
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "TRUE", "True", "true", "YES", "Yes", "yes", "1":
            return true
        case "FALSE", "False", "false", "NO", "No", "no", "0":
            return false
        default:
            return nil
        }
    }
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
}

extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
