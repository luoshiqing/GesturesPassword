//
//  PwdView.swift
//  GesturesPassword
//
//  Created by sqluo on 2017/3/24.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit


class PwdView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.yellow
        
        self.initButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let WIDTH = UIScreen.main.bounds.width
    
    fileprivate var passwordArray = [Int]()
    
    fileprivate let column = 5  //列
    fileprivate let line = 5    //行
    fileprivate let btnWH: CGFloat = 50
    
    fileprivate var btnArray = [UIButton]()
    fileprivate var selectBtnTagArray = [Int]()
    
    fileprivate var gesturePoint = CGPoint(x: 0, y: 0)
    
    fileprivate func initButtons(){
        
        //计算按钮的间隔
        let btnSpace = (WIDTH - CGFloat(self.column) * self.btnWH) / CGFloat(self.column + 1)
        
        let startY: CGFloat = 70
        
        for i in 0..<self.line { //控制y
            
            for j in 0..<self.column { //控制x
                
                let x = btnWH * CGFloat(j) + btnSpace * CGFloat(j + 1)
                
                let y = startY + btnWH * CGFloat(i) + btnSpace * CGFloat(i + 1)
                
                let btn = UIButton(frame: CGRect(x: x, y: y, width: btnWH, height: btnWH))
                
                btn.backgroundColor = UIColor.clear
                btn.isUserInteractionEnabled = false
                
                btn.layer.cornerRadius = btn.frame.width / 2.0
                btn.layer.masksToBounds = true
                
                btn.layer.borderColor = UIColor.red.cgColor
                btn.layer.borderWidth = 1
                
                btn.tag = i * self.column + j
                
                
                self.addSubview(btn)
                
                btnArray.append(btn)
            }
   
        }
        
        
    }
    
    
    
    //开始触摸
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectBtnTagArray.removeAll()
        self.touchesChange(touches)
    }
    //移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesChange(touches)
    }
    
    
    
    //结束触摸
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(self.selectBtnTagArray)
        
        for btn in self.btnArray {
            btn.backgroundColor = UIColor.clear
        }
        self.gesturePoint = CGPoint(x: 0, y: 0)
        //赋值给 密码 数组
        self.passwordArray = self.selectBtnTagArray
        //移除tag数组，恢复初始图
        self.selectBtnTagArray.removeAll()
        
        self.setNeedsDisplay()
    }
    
    
    fileprivate func touchesChange(_ touches: Set<UITouch>){
        //触摸的对象的点
        self.gesturePoint = touches.first!.location(in: self)
        
        for btn in self.btnArray{
            //手指坐标是否在按钮上，而且选择数组中不包含改数组的tag
            if btn.frame.contains(self.gesturePoint) && !self.selectBtnTagArray.contains(btn.tag){
                //处理跳跃连线，这个是两个btn之间的中心点
                var lineCenterPoint = CGPoint(x: 0, y: 0)
                
                if self.selectBtnTagArray.count > 0 {
                    let startP = btn.frame.origin
                    let endP = self.btnArray[self.selectBtnTagArray.last!].frame.origin
                    lineCenterPoint = self.centerPoint(start: startP, end: endP)
                }
                //处理中间跳跃的点,如果不需要，处理中心点，可以注释掉
                for btn in self.btnArray {
                    if btn.frame.contains(lineCenterPoint) && !self.selectBtnTagArray.contains(btn.tag) {
                        //保存跳跃的 中心 按钮 tag
                        btn.backgroundColor = UIColor.red
                        self.selectBtnTagArray.append(btn.tag)
                    }
                }
                //保存划过的按钮的tag
                self.selectBtnTagArray.append(btn.tag)
                btn.backgroundColor = UIColor.red
            }
        }
        self.setNeedsDisplay()
    }
    
    //计算两个节点中心的坐标
    fileprivate func centerPoint(start: CGPoint, end: CGPoint) -> CGPoint {
        
        let rightPoint  = start.x > end.x ? start.x : end.x
        let leftPoint   = start.x < end.x ? start.x : end.x
        
        let topPoint    = start.y > end.y ? start.y : end.y
        let bottomPoint = start.y < end.y ? start.y : end.y
        
        let x = (rightPoint + leftPoint) / 2 + self.btnWH / 2
        let y = (topPoint + bottomPoint) / 2 + self.btnWH / 2
        
        let point = CGPoint(x: x, y: y)
   
        return point
    }
    
    

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        var i = 0
        
        for tag in self.selectBtnTagArray {
            let x = btnArray[tag].center.x
            let y = btnArray[tag].center.y
            if i == 0 {
                context?.move(to: CGPoint(x: x, y: y))
            }else{
                context?.addLine(to: CGPoint(x: x, y: y))
            }
            i += 1
        }
        
        if self.selectBtnTagArray.count > 0 && self.gesturePoint != CGPoint(x: 0, y: 0){
            
            let x = self.gesturePoint.x
            let y = self.gesturePoint.y
            context?.addLine(to: CGPoint(x: x, y: y))
        }
        
        context?.setLineWidth(5)
        context?.setLineJoin(.round)
        context?.setLineCap(.round)
        context?.setStrokeColor(red: 227/255.0, green: 54/255.0, blue: 58/255.0, alpha: 1)
        context?.strokePath()
    }
 

}
