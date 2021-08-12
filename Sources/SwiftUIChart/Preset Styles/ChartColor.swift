//
//  ChartColor.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

public struct ChartColor {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    public static let accentColor: Color = .accentColor
    
    public static let lineLeadingColor: Color = accentColor.opacity(0.6)
    public static let lineTrailingColor: Color = accentColor
    public static let lineGradient: Gradient = Gradient(colors: [ChartColor.lineLeadingColor, ChartColor.lineTrailingColor])
    
    public static let areaTopColor: Color = accentColor.opacity(0.3)
    public static let areaBottomColor: Color = accentColor.opacity(0)
    public static let areaGradient: Gradient = Gradient(colors: [ChartColor.areaTopColor, ChartColor.areaBottomColor])
    
    public static let titleColor: Color = .primary
    public static let descriptionColor: Color = .secondary
    public static let highlightColor: Color = accentColor
    
    public static let backgroundColor: Color = Color(UIColor.systemBackground)
    public static let darkBackgroundColor: Color = Color(UIColor.secondarySystemBackground)
    
    public static let legendColor: Color = .secondary
    public static let legendLineColor: Color = Color(UIColor.tertiaryLabel)
    
    //public static let descriptionColor: Color = Color(hexString: "#E8E7EA")
    //public static let indicatorKnob: Color = Color(hexString: "#545454")
    
}
