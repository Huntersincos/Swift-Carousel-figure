 Swift学习实战-轮播图
 1 带有参数宏定义:
 public func SWiftCGrect(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat) -> CGRect {
 return CGRect(x:x,y:y,width:width,height:height)
 }
 2 便利构造器:
 convenience init(_ frame: CGRect,_ timeAnimation:CGFloat,_ pageControl:Bool)

3 定时器:
ios10以上设备: open class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Swift.Void) -> Timer
ios10以下设备:scheduledTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> Timer
RunLoop.current.add(imagescorviewTimer!, forMode: .commonModes)

4 代理delegate:
@objc protocol SendImageInfoToViewRetrunDataDelegate{
@objc optional func sendImageInfoToView(_ imageIndex:NSInteger,_ imageInfo:UIImageView)
}
4 销毁定时器:
deinit  {
if (figureImageViews?.imagescorviewTimer?.isValid)! {
figureImageViews?.imagescorviewTimer?.invalidate()
}
}
5 SDWebImage在swift中使用----混编
1 pod install :
pod ‘SDWebImage’,’~> 4.4.2’
use_frameworks!
2 imageView.sd_setImage(with: imageUrl as URL?, placeholderImage: placeImage, options: .retryFailed, completed: { (image:UIImage?, error:Error?, sdimageCashType:SDImageCacheType, url:URL?) in

})


