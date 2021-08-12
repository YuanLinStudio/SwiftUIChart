//
//  ChartStyle.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

public class ChartStyleSet {
    
    public var backgroundColor: Color
    public var accentColor: Color
    public var gradient: Gradient
    public var titleColor: Color
    public var descriptionColor: Color
    
    public init(backgroundColor: Color = ChartColor.backgroundColor,
                accentColor: Color = ChartColor.accentColor,
                gradient: Gradient = ChartColor.lineGradient,
                titleColor: Color = ChartColor.titleColor,
                descriptionColor: Color = ChartColor.descriptionColor) {
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.gradient = gradient
        self.titleColor = titleColor
        self.descriptionColor = descriptionColor
    }
}

public struct ChartStyle {
    
    public static let inherited: ChartStyleSet = ChartStyleSet()
    
}
