//
//  Extensions.swift
//  MyHabits
//
//  Created by Natali Malich on 18.08.2021.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach() { addSubview($0) }
    }
}

extension UIColor {
    static let navigationColor = UIColor(named: "NavigationColor")
    static let blueColor = UIColor(named: "BlueColor")
    static let greenColor = UIColor(named: "GreenColor")
    static let indigoColor = UIColor(named: "IndigoColor")
    static let lightGrayColor = UIColor(named: "LightGrayColor")
    static let orangeColor = UIColor(named: "OrangeColor")
    static let purpleColor = UIColor(named: "PurpleColor")
    
}

extension UIFont {
    static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let headLine = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let footnoteBold = UIFont.systemFont(ofSize: 13, weight: .semibold)
    static let footnoteStatus = UIFont.systemFont(ofSize: 13, weight: .semibold)
    static let footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
}
