//
//  Ext+Fonts.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 05.02.2024.
//

import SwiftUI

extension Font {
    // MARK: Montserrat Font
    static func montserrat(_ style: Montserrat, size: CGFloat) -> Font {
        return Font.custom(style.rawValue, size: size)
    }

    enum Montserrat: String {
        case black = "Montserrat-Black"
        case blackItalic = "Montserrat-BlackItalic"
        case bold = "Montserrat-Bold"
        case boldItalic = "Montserrat-BoldItalic"
        case extraBold = "Montserrat-ExtraBold"
        case extraBoldItalic = "Montserrat-ExtraBoldItalic"
        case extraLight = "Montserrat-ExtraLight"
        case extraLightItalic = "Montserrat-ExtraLightItalic"
        case italic = "Montserrat-Italic"
        case light = "Montserrat-Light"
        case medium = "Montserrat-Medium"
        case mediumItalic = "Montserrat-MediumItalic"
        case regular = "Montserrat-Regular"
        case semibold = "Montserrat-Semibold"
        case semiboldItalic = "Montserrat-SemiboldItalic"
    }
}

