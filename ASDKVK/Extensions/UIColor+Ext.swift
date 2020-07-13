//
//  UIColor+Ext.swift
//  L1_Selezneva_Valentina_
//
//  Created by user on 22/12/2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        UIColor(red: CGFloat.random(in: 0...255)/255,
                green: CGFloat.random(in: 0...255)/255,
                blue: CGFloat.random(in: 0...255)/255,
                alpha: 1)
    }
}
