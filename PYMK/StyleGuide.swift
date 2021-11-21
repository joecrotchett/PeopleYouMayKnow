//
//  StyleGuide.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

struct StyleGuide {
    static func apply(to window: UIWindow) {
        let navBar = UINavigationBar.appearance()
        navBar.titleTextAttributes = [.foregroundColor : StyleGuide.Colors.yellow]
    }

    struct Colors {
        static var yellow = UIColor(0xE7B547)
    }
}

// MARK: UIColor

extension UIColor {
    
    convenience init(_ hex: UInt32, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


