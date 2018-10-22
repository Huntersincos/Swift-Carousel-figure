//
//  CarouseFIgureImageView.swift
//  CarousefigureSwift
//
//  Created by wenze on 2018/10/19.
//  Copyright © 2018年 wenze. All rights reserved.
//

import UIKit
import SDWebImage
/** 图片点击事件回调    */
@objc protocol SendImageInfoToViewRetrunDataDelegate{
    @objc optional func sendImageInfoToView(_ imageIndex:NSInteger,_ imageInfo:UIImageView)
}
class CarouseFIgureImageView: UIView,UIScrollViewDelegate {
    /** 当前滚动父试图 */
    private  var scrollView:UIScrollView?
    private  var pageView:UIPageControl?
    /** 滚动定时器 */
    public  var imagescorviewTimer:Timer?
    /** imageIndex */
    private  var page:NSInteger?
    /** 代理delegate */
    public weak var delegate:SendImageInfoToViewRetrunDataDelegate?
    /**
      @param timeAnimation 倒计时时间
      @param pageControl 是否需要UIPageControl
      @author wenze
     **/
    convenience init(_ frame: CGRect,_ timeAnimation:CGFloat,_ pageControl:Bool) {
        self.init(frame: frame)
        pageView = UIPageControl.init(frame:SWiftCGrect(x: 0, y: frame.size.height - 10, width: frame.size.width, height: 10))
        self.addSubview(pageView!);
        if #available(iOS 10.0, *) {
            imagescorviewTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeAnimation), repeats: true, block: { (scorviewTimer:Timer) in
                self.pageView?.currentPage = self.page!
                self.page = (Int)((self.scrollView?.contentOffset.x)!/(self.scrollView?.frame.size.width)!)
                self.page = self.page! + 1
                UIView.animate(withDuration: 0.5) {
                    self.scrollView?.contentOffset = CGPoint(x:(self.scrollView?.frame.size.width)! * CGFloat(self.page!) ,y:0)
                }
                if self.page == Int((self.scrollView?.contentSize.width)!/(self.scrollView?.frame.width)! - 1) {
                    self.page = 1
                    self.pageView?.currentPage = 1;
                    self.scrollView?.contentOffset = CGPoint(x:(self.scrollView?.frame.size.width)!,y:0)
                }
                
            })
        } else {
            // Fallback on earlier versions
            imagescorviewTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeAnimation), target: self, selector:#selector(timeActionClick(_ :)), userInfo: nil, repeats: true)
            RunLoop.current.add(imagescorviewTimer!, forMode: .commonModes)
        }
      
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        scrollView = UIScrollView.init(frame:CGRect(x:0,y:0,width:frame.size.width,height:frame.size.height))
        scrollView?.isPagingEnabled = true;
        scrollView?.showsHorizontalScrollIndicator = false;
        scrollView?.showsVerticalScrollIndicator = false;
        scrollView?.delegate = self;
        self.addSubview(scrollView!);
        
    }
    
    /**
     @param imageViewArray 图片网络数据
     @param imagePlaceHolderImage 展位图
     @param isScrol是否轮播
     @author wenze
     **/
    func creatScrolView(_ imageViewArray:NSMutableArray,_ imagePlaceHolderImage:String,_ isScrol:Bool) {
        self.page = 1;
        let offsize:CGSize = self.frame.size
        for views:UIView in (self.scrollView?.subviews)! {
            if views.isKind(of: UIImageView.self){
                views.removeFromSuperview()
            }
        }
        if isScrol {
            self.pageView?.numberOfPages = imageViewArray.count
            self.pageView?.currentPageIndicatorTintColor = UIColor.red;
            self.pageView?.pageIndicatorTintColor = UIColor.yellow;
            self.pageView?.currentPage = 0;
            self.pageView?.isEnabled = false
            self.pageView?.alpha = 1;
            /**  1,2,3 -> 3,1,2,3,1 */
            imageViewArray.insert(imageViewArray.lastObject!, at: 0)
            imageViewArray.add(imageViewArray.object(at: 1))
            self.scrollView?.contentSize = CGSize(width:offsize.width * CGFloat(imageViewArray.count),height:0)
            self.scrollView?.contentOffset = CGPoint(x:offsize.width,y:0);
            self.imagescorviewTimer?.fire()
            self.scrollView?.isScrollEnabled = true
           
        }else{
            self.imagescorviewTimer?.fireDate = NSDate.distantFuture;
            self.scrollView?.isScrollEnabled = false;
            self.scrollView?.contentOffset = CGPoint(x:0,y:0)
            self.scrollView?.alpha = 0;
        }
        self.scrollView?.backgroundColor = UIColor.white;
        //for循环 for（int i=0；i<10;i++）{}在Swift3.0已经移除掉了，
        //for(var i = 0 ;i <= imageViewArray.count; i++)
        for (index,value) in imageViewArray.enumerated() {
            let imageView  = UIImageView.init(frame: SWiftCGrect(x: CGFloat(index) * offsize.width, y: 0, width: offsize.width, height:(self.scrollView?.frame.height)!))
             scrollView?.addSubview(imageView)
             imageView.isUserInteractionEnabled = true
             let imageUrl = NSURL.init(string:value as! String)
             let placeImage:UIImage = UIImage.init(named: imagePlaceHolderImage)!
            imageView.sd_setImage(with: imageUrl as URL?, placeholderImage: placeImage, options: .retryFailed, completed: { (image:UIImage?, error:Error?, sdimageCashType:SDImageCacheType, url:URL?) in

            })
            imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_ :))))
            
        }
        
    }
    
    /** scrollivewDelegate */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /** 滚动到最后一页,在返回第一页  */
        if scrollView.contentOffset.x == scrollView.contentSize.width - self.frame.width {
            pageView?.currentPage = 1
            page = 1;
           // scrollView.contentOffset  = CGPoint(x:scrollView.frame.size.width,y:0)
        }
        /**  当偏移量为零时 */
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset = CGPoint(x:scrollView.contentSize.width - 2*self.frame.width,y:0);
            pageView?.currentPage = Int(scrollView.contentOffset.x/self.frame.width - 1);
            page = pageView?.currentPage
        }
        pageView?.currentPage = Int(scrollView.contentOffset.x/self.frame.size.width) - 1
        page = Int(scrollView.contentOffset.x/self.frame.size.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.contentSize.width - self.frame.width {
            scrollView.contentOffset  = CGPoint(x:scrollView.frame.size.width,y:0);
            pageView?.currentPage =  1;
            page = 1

        }
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset = CGPoint(x:scrollView.contentSize.width - 2*self.frame.width,y:0);
            pageView?.currentPage = Int(scrollView.contentOffset.x/self.frame.width - 1);
            page = pageView?.currentPage
        }
        pageView?.currentPage = Int(scrollView.contentOffset.x/self.frame.size.width) - 1
        page = Int(scrollView.contentOffset.x/self.frame.size.width)
    }
    /**
     @param time 倒计时
     @author wenze
     **/
    @objc func timeActionClick(_ time:Timer) {
        pageView?.currentPage = page!
        page = (Int)((scrollView?.contentOffset.x)!/(scrollView?.frame.size.width)!)
        page = page! + 1
        UIView.animate(withDuration: 0.5) {
            self.scrollView?.contentOffset = CGPoint(x:(self.scrollView?.frame.size.width)! * CGFloat(self.page!) ,y:0)
        }
        if page == Int((scrollView?.contentSize.width)!/(scrollView?.frame.width)! - 1) {
            page = 1
            pageView?.currentPage = 1;
            scrollView?.contentOffset = CGPoint(x:(scrollView?.frame.size.width)!,y:0)
        }
    }
    
    /**
     @param tap 图片点击事件
     @author wenze
     **/
    @objc func tapAction(_ tap:UITapGestureRecognizer){
        let imageView = tap.view as! UIImageView?
        var index = page
        if index == 0 {
            index = Int((scrollView?.contentSize.width)!/(scrollView?.frame.size.width)! - 3);
            self.delegate?.sendImageInfoToView!(index!, imageView!)
            return
        }
        if index == Int((scrollView?.contentSize.width)!/(scrollView?.frame.width)!) - 1{
            index = 0
            self.delegate?.sendImageInfoToView!(index!, imageView!)
            return
        }
       // index-- swift3.0去掉了
        index = index! - 1
        self.delegate?.sendImageInfoToView!(index!, imageView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
