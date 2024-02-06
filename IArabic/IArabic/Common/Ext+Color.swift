//
//  Ext+Color.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 05.02.2024.
//

import SwiftUI

extension Color {
    
    static var custom: CustomColor { return CustomColor() }
    
    struct CustomColor {
        // Orange
        var customOrange: Color { Color("customOrange", bundle: nil) }
        
        // Blue
        var blue: Color { Color("customBlue", bundle: nil) }
        
        // Light Blue
        var lightBlue: Color { Color("customlightBlue", bundle: nil) }
        
        // Black
        var black: Color { Color("customBlack", bundle: nil) }
        
        // White
        var white: Color { Color("customWhite", bundle: nil) }
        
        // Light Green
        var lightGreen: Color { Color("customLightGreen", bundle: nil) }
        
        // Red
        var red: Color { Color("customRed", bundle: nil) }
        
        // Violet
        var violet: Color { Color("customViolet", bundle: nil) }
        
        // Background Color
        var backgroundColor: Color { Color("customBackgroundColor", bundle: nil) }
        
        // Yellow
        var yellow: Color { Color("customYellow", bundle: nil) }
        
        // Light Gray
        var lightGray: Color { Color("customLightGray", bundle: nil) }
        
        // Light Yellow
        var lightYellow: Color { Color("customlightYellow", bundle: nil) }
        
        // Light White
        var lightWhite: Color { Color("customlightWhite", bundle: nil) }
    }
}

