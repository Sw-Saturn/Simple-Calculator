//
//  TestPage.swift
//  Calculator
//
//  Created by Kanta Demizu on 12/21/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import UIKit

class TestPage: UIPageViewController,UIPageViewControllerDataSource {
    let sboard: UIStoryboard? = UIStoryboard(name:"Main", bundle:nil)
    let pageList = ["First","Second"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = storyboard?.instantiateViewControllerWithIdentifier(pageList.first!)
        self.setViewControllers([controller!], direction: .Forward, animated: true, completion: nil)
        self.dataSource=self

        // Do any additional setup after loading the view.
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = pageList.indexOf(viewController.restorationIdentifier!)!
        if (index > 0) {
            //前ページのビューコントローラーを返す。
            return storyboard!.instantiateViewControllerWithIdentifier(pageList[index-1])
        }
        return nil
    }
    
    
    
    //左ドラッグ時の呼び出しメソッド
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        //現在のビューコントローラーのインデックス番号を取得する。
        let index = pageList.indexOf(viewController.restorationIdentifier!)!
        if (index < pageList.count-1) {
            //次ページのビューコントローラーを返す。
            return storyboard!.instantiateViewControllerWithIdentifier(pageList[index+1])
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
