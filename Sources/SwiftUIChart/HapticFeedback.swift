//
//  HapticFeedback.swift
//  
//
//  Created by 袁林 on 2021/8/12.
//

import Foundation
import SwiftUI

class HapticFeedback {
    
    #if os(watchOS)
    // watchOS implementation
    
    static func SelectionChanged() -> Void {
        WKInterfaceDevice.current().play(.click)
    }
    
    static func Success() -> Void {
        self.SelectionChanged()
    }
    
    static func Error() -> Void {
        self.SelectionChanged()
    }
    
    #else
    // iOS implementation
    
    static func SelectionChanged() -> Void {
        UISelectionFeedbackGenerator().selectionChanged()
        UISelectionFeedbackGenerator().prepare()
    }
    
    static func Success() -> Void {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    static func Error() -> Void {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    #endif
}

