//
//  UIFont+AppFonts.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static var title: UIFont { return UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium) }
    
    static var text: UIFont { return UIFont.systemFont(ofSize: UIFont.dynamicFontSize) }
    static var textStrong: UIFont { return UIFont.systemFont(ofSize: UIFont.dynamicFontSize, weight: .bold) }
    static var textItalic: UIFont { return UIFont.italicSystemFont(ofSize: UIFont.dynamicFontSize) }
    static var textItalicStrong: UIFont { return UIFont.text.with(traits: [.traitBold, .traitItalic]) }
    
    static var secondaryText: UIFont { return UIFont.systemFont(ofSize: UIFont.fontSize - 3) }
    
    static var postTitle: UIFont { return UIFont.systemFont(ofSize: UIFont.fontSize + 2, weight: .semibold) }
    static var postTitleExtra: UIFont { return UIFont.systemFont(ofSize: UIFont.fontSize + 5, weight: .semibold) }
    
    static var largeSubtitle: UIFont { return UIFont.systemFont(ofSize: 34, weight: .semibold) }
    static var largeTitle: UIFont { return UIFont.systemFont(ofSize: 34, weight: .bold) }
    
    static var postNumber: UIFont { return UIFont.systemFont(ofSize: UIFont.dynamicFontSize + 2, weight: .semibold) }
    static var postSmall: UIFont { return UIFont.systemFont(ofSize: UIFont.dynamicFontSize - 3) }
    
    
    static var onboardTitle: UIFont { return UIFont.systemFont(ofSize: 32, weight: .semibold) }
    static var onboardSubtitle: UIFont { return UIFont.systemFont(ofSize: 18, weight: .regular) }
    
    static var tinySmallText: UIFont { return UIFont.systemFont(ofSize: UIFont.fontSize - 2, weight: .light) }

    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    static var fontSize: CGFloat {
        let userFont =  UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body)
        
        var size = userFont.pointSize
        if IsIpad {
//            size += 2
        } else {
            size -= 2
        }

        
        return 15.0
    }
    
    static var dynamicFontSize: CGFloat {
        let userFont =  UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body)
        
        var size = userFont.pointSize
        if IsIpad {
            //            size += 2
        } else {
            size -= 2
        }
        
        
        return size

    }
    
    



}
