//
//  ViewController.swift
//  CarousefigureSwift
//
//  Created by wenze on 2018/10/18.
//  Copyright © 2018年 wenze. All rights reserved.
//

import UIKit
/** 有参数的宏 CGRect*/
public func SWiftCGrect(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat) -> CGRect {
    return CGRect(x:x,y:y,width:width,height:height)
}
class ViewController: UIViewController,SendImageInfoToViewRetrunDataDelegate {
    /** 轮播-subview   **/
    var figureImageViews:CarouseFIgureImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       figureImageViews = CarouseFIgureImageView.init(SWiftCGrect(x: 0, y: 0, width: self.view.frame.size.width, height: 160), 5, true)
       figureImageViews?.delegate = self
       let imageArray:NSMutableArray = NSMutableArray.init()
       imageArray.add("https://www.gx.10086.cn/zt-portal/nav/common/upload/1536737465280.jpg")
       imageArray.add("https://www.gx.10086.cn/zt-portal/nav/common/upload/1536737619792.jpg")
       imageArray.add("https://www.gx.10086.cn/zt-portal/nav/common/upload/1536737666753.jpg")
       figureImageViews?.creatScrolView(imageArray, "1.jpeg", true)
      self.view.addSubview(figureImageViews!)
    
    }
    /**  sendImageInfoToViewDelegate */
    func sendImageInfoToView(_ imageIndex: NSInteger, _ imageInfo: UIImageView) {
        
    }
    /**销毁定时器 */
    deinit  {
        if (figureImageViews?.imagescorviewTimer?.isValid)! {
            figureImageViews?.imagescorviewTimer?.invalidate()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

