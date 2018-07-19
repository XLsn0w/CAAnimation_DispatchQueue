//
//  UIImageExtend.swift
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/19.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

import UIKit

extension UIImage {
    
    //创建一个方法，传递一个图像参数和一个缩放的参数，实现将图像缩放至指定比例的功能
    func scaleImage12(image:UIImage,newSize:CGSize) -> UIImage{
        
        let imageSize = image.size
        let width = imageSize.width
        //获取源图像的高
        let height = imageSize.height
        //计算图像新尺寸与旧尺寸的款高比
        let widthFactor = newSize.width/width
        let heightFactor = newSize.height/height
        //获取最小的比例值
        let scaleFactor = (widthFactor<heightFactor) ? widthFactor :heightFactor
        //计算图像新的宽高，并将新宽高构建成标准的CGSize对象
        let scaleWith = width * scaleFactor
        let scaleHeight = height * scaleFactor
        let  targetSize = CGSize(width:scaleWith,height:scaleHeight)
        
        UIGraphicsBeginImageContext(targetSize)
        image.draw(in: CGRect(x:0,y:0,width:scaleWith,height:scaleHeight))
        //获取上下文内容，将内容写到新的图像对象中
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage!
        
    }
    /// 添加文字水印
    ///
    /// - Parameters:
    ///   - image: 要添加水印的图片
    ///   - text: 要添加的文字水印
    ///   - position: 文字水印的位置
    ///   - attributes: 文字水印的样式
    /// - Returns: 添加了水印的图片
    func addTextMark(image: UIImage, text: NSString, position: CGPoint, attributes: NSDictionary) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        text.draw(at: position, withAttributes: (attributes as! [NSAttributedStringKey : Any]))
        let newImg = UIGraphicsGetImageFromCurrentImageContext() as UIImage?
        UIGraphicsEndImageContext()
        
        return newImg!
    }
    
    
    /// 添加图片水印
    ///
    /// - Parameters:
    ///   - image: 要添加水印的图片
    ///   - markImage: 水印图片
    ///   - position: 水印图片的位置
    /// - Returns: 添加了水印的图片
    func addImageMark(image: UIImage, markImage: UIImage, position: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        markImage.draw(in: position)
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage?
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /// 截图
    func shortCut(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        let currContext = UIGraphicsGetCurrentContext()
        view.layer.render(in: currContext!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage?
        UIGraphicsEndImageContext()
        
        return image!
    }
}
