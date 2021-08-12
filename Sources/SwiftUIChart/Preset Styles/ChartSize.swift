//
//  ChartSize.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

public struct ChartSize {
    
    #if os(watchOS)
    public static let small = CGSize(width: 120, height: 90)
    public static let medium = CGSize(width: 120, height: 160)
    public static let large = CGSize(width: 180, height: 90)
    public static let extraLarge = CGSize(width: 180, height: 90)
    public static let detail = CGSize(width: 180, height: 160)
    
    #else
    public static let small = CGSize(width: 180, height: 120)
    public static let medium = CGSize(width: 180, height: 240)
    public static let large = CGSize(width: 360, height: 120)
    public static let extraLarge = CGSize(width: 360, height: 240)
    public static let detail = CGSize(width: 180, height: 120)
    #endif
}
