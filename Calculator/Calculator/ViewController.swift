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
import GoogleMobileAds

extension UIView {
    func removeAllSubviews(){
        let subviews = self.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

class ViewController: UIViewController, GADBannerViewDelegate {
    var admobView: GADBannerView = GADBannerView()
    let AdMobID = "ca-app-pub-3940256099942544/2934735716"
    let TEST_DEVICE_ID = "1405b75230153994f6a6e2831cb8588d"
    let AdMobTest:Bool = true
    let SimulatorTest:Bool = true
    
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
        self.banner_ads()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        admobView.frame.origin = CGPointMake(0, self.view.frame.height - admobView.frame.height)
        admobView.frame.size = CGSizeMake(self.view.frame.width, admobView.frame.height)
    }
    
    func banner_ads(){
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.frame.origin = CGPointMake(0, self.view.frame.height - admobView.frame.height)
        admobView.frame.size = CGSizeMake(self.view.frame.width, admobView.frame.height)
        admobView.adUnitID = AdMobID
        admobView.delegate = self
        admobView.rootViewController = self
        
        let admobRequest:GADRequest = GADRequest()
        
        if AdMobTest {
            if SimulatorTest {
                admobRequest.testDevices = [kGADSimulatorID]
            }
            else {
                admobRequest.testDevices = [TEST_DEVICE_ID]
            }
        }
        admobView.loadRequest(admobRequest)
        self.view.addSubview(admobView)
    }
    
    @IBOutlet weak var NumView: UILabel!
    @IBOutlet weak var Calculation: UILabel!
    var Num:String="0",Symbol:String = "Null",NumA:Int = 0,NumB:Double = 0,NumC:Double = 0,Ans:Double = 0.0,AnsCal:String="",BoolSym:Bool = false,CalText:String = "",Cal:String="",appendLastNumber:String="",endPoint:Int=0
    let rpnconv=convertRPN(),fontSizeofUIButton = UIButton(),CalSym = ["+","-","×","÷"]
    
    /*入力*/
    
    //数字入力
    func inputNumber(){
        let pmArray = NumView.text!.characters.split{ $0 == " " }.map(String.init)
        if (NumView.text=="0"||NumView.text=="Error"){
            NumView.text=""
        }
        if pmArray.last!.characters.count > 20 {
        }
            
        else if pmArray.last!.characters.count <= 20 {
            NumView.text = NumView.text?.stringByAppendingString(String(format: "%d",NumA))
        }
    }
    //計算記号入力
    func inputSymbol(){
        print(NumView.text!)
        if ((Calculation.text?.rangeOfString(AnsCal)) != nil) {
            NumView.text = NumView.text?.stringByAppendingString(" ")
            NumView.text = NumView.text?.stringByAppendingString("\(Symbol)")
            NumView.text = NumView.text?.stringByAppendingString(" ")
        }
        else{
            NumView.text = NumView.text?.stringByAppendingString(" ")
            NumView.text = NumView.text?.stringByAppendingString("\(Symbol)")
            NumView.text = NumView.text?.stringByAppendingString(" ")
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
        if BoolSym == true {
            NumView.text = NumView.text?.stringByAppendingString(" ( ")
            BoolSym=true
        }
    }
    
    //閉じカッコ
    func pressParenthesisEnd() {
        let FromParenthesisSt = NumView.text?.rangeOfString("( ")
        print(FromParenthesisSt)
        if NumView.text?.hasSuffix(" ) ") == true {
        }
        else if FromParenthesisSt != nil {
            CalText = NumView.text!.substringWithRange(Range(FromParenthesisSt!.endIndex ..< NumView.text!.endIndex))
            print("CalTextIs\(CalText)")
            BoolSym = (NumView.text?.hasSuffix("\(CalText)"))!
            print(BoolSym)
        }
        if NumView.text == "0" {
        }
        if BoolSym == true {
            NumView.text = NumView.text?.stringByAppendingString(" ) ")
            BoolSym = false
        }
    }
    
    //イコール動作
    func pressEqual() {
        if (Calculation.text=="Welcome."&&Calculation.text=="0") {
            Calculation.text="0"
        }
        if Calculation.text?.hasSuffix("Error") == true || (NumView.text?.hasSuffix("nan"))! {
            Calculation.text = NumView.text?.stringByAppendingString(" = Error")
            NumView.text = "Error"
        }
        else {
            if ((NumView.text?.stringByAppendingString("%"))! == true) {
                let pmArray = NumView.text!.characters.split{ $0 == " " }.map(String.init)
                CalText = NumView.text!
                endPoint = (NumView.text?.utf16.count)!-(pmArray.last?.utf16.count)!
                NumView.text=NumView.text?.substringToIndex(NumView.text!.startIndex.advancedBy(endPoint))
                NumView.text=NumView.text?.stringByAppendingString(String(format: "%g",Double(pmArray.first!)!*Double(pmArray.last!)!*0.01))
                
            }
            print(NumView.text)
            CalText = NumView.text!
            print("CalTextIs \'\(CalText)\'")
            Cal=rpnconv.parseInfix(CalText)
            print("CalIs \'\(Cal)\'")
            if Cal == "" {
            }
            else {
                if RPNCalc(Cal)=="+∞" {
                    NumView.text = "Error"
                    Calculation.text=CalText.stringByAppendingString(" = ").stringByAppendingString("Error")
                }
                else {
                    let Ans:Double = Double(RPNCalc(Cal))!
                    NumView.text = String(Ans)
                    if ((NumView.text?.hasPrefix(".0")) != nil) {
                        NumView.text = RPNCalc(Cal)
                        print(NumView.text)
                        Calculation.text=CalText.stringByAppendingString(" = ").stringByAppendingString(RPNCalc(Cal))
                    }
                    else {
                        print(NumView.text)
                        Calculation.text=CalText.stringByAppendingString(" = ").stringByAppendingString(String(Ans))
                    }
                }
            }
            AnsCal=Calculation.text!
        }
    }
    
    //マイナスつけたり消したり
    func pressMinus() {
        var pmArray = NumView.text!.characters.split{ $0 == " " }.map(String.init)
        print("pmArrayIs\(pmArray)")
        if pmArray.last == Symbol {
        }
        if (pmArray.last?.rangeOfString("-") != nil) {
            let range = NumView.text?.rangeOfString("\(pmArray.last)")
            NumView.text = NumView.text?.stringByReplacingOccurrencesOfString("-", withString: "", range:range )
        }
        else {
            endPoint = (NumView.text?.utf16.count)!-(pmArray.last?.utf16.count)!
            NumView.text=NumView.text?.substringToIndex(NumView.text!.startIndex.advancedBy(endPoint))
            let appendLastNumber = "-" + pmArray.last!
            NumView.text = NumView.text?.stringByAppendingString(appendLastNumber)
        }
        pmArray = NumView.text!.characters.split{ $0 == " " }.map(String.init)
        print("pmArrayAfterMinusIs\(pmArray)")
    }
    
    //1文字消去
    func deleteLastNumber()  {
        if NumView.text! != "" {
            if NumView.text?.utf16.count == 1 {
                NumView.text! = "0"
            }
            else   {
                if NumView.text?.characters.last==" " {
                    endPoint = (NumView.text?.utf16.count)!-3
                    NumView.text=NumView.text?.substringToIndex(NumView.text!.startIndex.advancedBy(endPoint))
                }
                else {
                    endPoint = (NumView.text?.utf16.count)!-1
                    NumView.text=NumView.text?.substringToIndex(NumView.text!.startIndex.advancedBy(endPoint))
                }
            }
        }
    }
    
    //パーセント計算
    func pressPercent() {
        var pmArray = NumView.text!.characters.split{ $0 == " " }.map(String.init)
        print("pmArrayIs\(pmArray)")
        if pmArray.last == Symbol || pmArray.count==1{
        }
        else{
            endPoint = (NumView.text?.utf16.count)!-(pmArray.last?.utf16.count)!
            NumView.text=NumView.text?.substringToIndex(NumView.text!.startIndex.advancedBy(endPoint))
            let lastArray=pmArray.last
            if NumView.text?.rangeOfString(" ) ") != nil {
                let startArrPoint:Int = pmArray.indexOf("(")!+1
                print(startArrPoint)
                let endArrPoint:Int = pmArray.indexOf(")")!
                print(endArrPoint)
                let calArray = pmArray[startArrPoint..<endArrPoint]
                print(calArray)
                let cal:String = calArray.joinWithSeparator(" ")
                let perCal=rpnconv.parseInfix(cal)
                let perAns=RPNCalc(perCal)
                print(perCal)
                print(perAns)
                NumView.text=NumView.text?.stringByAppendingString(String(format: "%g",Double(perAns)!*Double(lastArray!)!*0.01))
            }
            else{
                pmArray.removeLast()
                pmArray.removeLast()
                NumView.text=NumView.text?.stringByAppendingString(String(format: "%g",Double(pmArray.last!)!*Double(lastArray!)!*0.01))
            }
        }
    }
    
    //計算
    func RPNCalc(input:String) -> String {
        let strs = input.componentsSeparatedByString(" ")
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 20
        var numberStack:[Double] = []
        var result: String? = nil
        for one in strs {
            var number = formatter.numberFromString(one)?.doubleValue
            print("NumberIs \(number)")
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
                result = formatter.stringFromNumber(numberStack[0])
            }
        }
        return result!
    }
    
    //タップ時の効果音
    func tapSound(soundName:String){
        var soundIdRing:SystemSoundID = 0
        let soundPath = NSURL(fileURLWithPath: "/System/Library/Audio/UISounds/\(soundName)")
        AudioServicesCreateSystemSoundID(soundPath, &soundIdRing)
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
        if NumView.text?.rangeOfString(".") == nil {
            NumView.text = NumView.text?.stringByAppendingString(".")
        }
    }
    
    
    /*ボタン動作*/
    
    @IBAction func Button00(sender: UIButton) {
        tapSound("Tock.caf")
        if NumView.text != "0" {
            NumA=00
            inputNumber()
        }
    }
    @IBAction func ButtonRoot(sender: UIButton) {
        tapSound("Tock.caf")
        let pmArray = NumView.text!.characters.split{ $0 == " " }.map(String.init)
        print(pmArray)
        if pmArray.last==Symbol {
            let alert:UIAlertController=UIAlertController(title: "Information", message: " √x ボタンは計算結果のみ使用できます", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction:UIAlertAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
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
    @IBAction func ButtonDecimal(sender: UIButton) {
        tapSound("Tock.caf")
        pressDecimal()
    }
    @IBAction func ButtonDelete(sender: UIButton) {
        tapSound("Tock.caf")
        deleteLastNumber()
    }
    @IBAction func ButtonCancel(sender: UIButton) {
        tapSound("Tock.caf")
        pressCancel()
    }
    @IBAction func Button0(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=0
        inputNumber()
    }
    @IBAction func Button1(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=1
        inputNumber()
    }
    @IBAction func Button2(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=2
        inputNumber()
    }
    @IBAction func Button3(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=3
        inputNumber()
    }
    @IBAction func Button4(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=4
        inputNumber()
    }
    @IBAction func Button5(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=5
        inputNumber()
    }
    @IBAction func Button6(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=6
        inputNumber()
    }
    @IBAction func Button7(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=7
        inputNumber()
    }
    @IBAction func Button8(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=8
        inputNumber()
    }
    @IBAction func Button9(sender: UIButton) {
        tapSound("Tock.caf")
        NumA=9
        inputNumber()
    }
    @IBAction func ButtonPlus(sender: UIButton) {
        tapSound("Tock.caf")
        print(NumView.text?.hasSuffix("\(Symbol) "))
        if (NumView.text?.hasSuffix("\(Symbol) ")) == false {
            Symbol="+"
            inputSymbol()
        }
    }
    @IBAction func ButtonMinus(sender: UIButton) {
        tapSound("Tock.caf")
        if NumView.text != "0" && NumView.text?.hasSuffix("\(Symbol) ") == false {
            Symbol="-"
            inputSymbol()
        }
    }
    @IBAction func ButtonCross(sender: UIButton) {
        tapSound("Tock.caf")
        print(NumView.text?.hasSuffix("\(Symbol) "))
        if (NumView.text?.hasSuffix("\(Symbol) ")) == false {
            Symbol="×"
            inputSymbol()
        }
    }
    @IBAction func ButtonSlash(sender: UIButton) {
        tapSound("Tock.caf")
        print(NumView.text?.hasSuffix("\(Symbol) "))
        if (NumView.text?.hasSuffix("\(Symbol) ")) == false {
            Symbol="÷"
            inputSymbol()
        }
    }
    @IBAction func ButtonParenthesisSt(sender: UIButton) {
        tapSound("Tock.caf")
        pressParenthesisStart()
    }
    @IBAction func ButtonParenthesisEn(sender: UIButton) {
        tapSound("Tock.caf")
        pressParenthesisEnd()
        let pmArray = NumView.text!.characters.split{ $0 == " " }.map(String.init)
        BoolSym=(pmArray.last==Symbol)
        print(BoolSym)
        if NumView.text=="0" {
            NumView.text = " ( "
        }
        if NumView.text?.hasSuffix(" ( ") == true {
        }
        if BoolSym == true {
            NumView.text = NumView.text?.stringByAppendingString(" ( ")
            BoolSym=true
        }
    }
    @IBAction func ButtonPercent(sender: UIButton) {
        tapSound("Tock.caf")
        pressPercent()
    }
    @IBAction func ButtonPlusMinus(sender: UIButton) {
        tapSound("Tock.caf")
        pressMinus()
    }
    @IBAction func ButtonEqual(sender: UIButton) {
        tapSound("Tock.caf")
        pressEqual()
    }
}
