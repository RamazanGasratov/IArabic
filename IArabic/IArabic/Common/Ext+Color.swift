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
        var blue: Color { Color("blue", bundle: nil) }
        
        // Light Blue
        var lightBlue: Color { Color("lightBlue", bundle: nil) }
        
        // Black
        var black: Color { Color("black", bundle: nil) }
        
        // White
        var white: Color { Color("white", bundle: nil) }
        
        // Light Green
        var lightGreen: Color { Color("lightGreen", bundle: nil) }
        
        // Red
        var red: Color { Color("red", bundle: nil) }
        
        // Dark Gray
        var darkGray: Color { Color("darkGray", bundle: nil) }
        
        // Violet
        var violet: Color { Color("violet", bundle: nil) }
        
        // Background Color
        var backgroundColor: Color { Color("backgroundColor", bundle: nil) }
        
        // Yellow
        var yellow: Color { Color("yellow", bundle: nil) }
        
        // Light Gray
        var lightGray: Color { Color("lightGray", bundle: nil) }
        
        // Light Yellow
        var lightYellow: Color { Color("lightYellow", bundle: nil) }
        
        // Light White
        var lightWhite: Color { Color("lightWhite", bundle: nil) }
    }
}

