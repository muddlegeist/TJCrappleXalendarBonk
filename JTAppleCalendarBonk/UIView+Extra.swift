//
//  UIView+Extra.swift
//   
//
//  Created by Scott Puhl on 2/7/17.
//  Copyright © 2017 Muddlegeist Inc. All rights reserved.
//

import UIKit
import EasyPeasy

extension UIView
{
    func roundCorners(_ radius:CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func roundCorners(radius:CGFloat, corners:UIRectCorner)
    {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width:radius, height:radius) )
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func makeRound()
    {
        let saveCenter = self.center
        var dimension = self.frame.size.width
        if dimension > self.frame.size.height
        {
            dimension = self.frame.size.height
        }
        
        
        let newFrame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width:dimension, height:dimension)
        self.frame = newFrame
        self.layer.cornerRadius = dimension / 2.0
        self.center = saveCenter
    }
}


