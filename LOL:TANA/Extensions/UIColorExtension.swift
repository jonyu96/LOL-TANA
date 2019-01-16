//
//  UIColorExtension.swift
//  LOL:TANA
//
//  Created by Jonathan Yu on 12/2/18.
//  Copyright © 2018 Jonathan Yu. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 216, g: 56, b: 17)
    static let trackStrokeColor = UIColor.rgb(r: 33, g: 66, b: 99)
    static let pulsatingFillColor = UIColor.rgb(r: 00, g: 33, b: 69)
    
}
