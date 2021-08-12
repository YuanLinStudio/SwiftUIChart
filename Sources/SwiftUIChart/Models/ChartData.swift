//
//  ChartData.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

public class ChartData: ObservableObject, Identifiable {
    
    @Published var points: [(String, Double)]
    var valuesGiven: Bool = false
    var ID = UUID()
    
    public init<N: BinaryFloatingPoint>(points: [N]) {
        self.points = points.map{("", Double($0))}
    }
    
    public init<N: BinaryInteger>(values: [(String, N)]) {
        self.points = values.map{($0.0, Double($0.1))}
        self.valuesGiven = true
    }
    
    public init<N: BinaryFloatingPoint>(values: [(String, N)]) {
        self.points = values.map{($0.0, Double($0.1))}
        self.valuesGiven = true
    }
    
    public init<N: BinaryInteger>(numberValues: [(N, N)]) {
        self.points = numberValues.map{(String($0.0), Double($0.1))}
        self.valuesGiven = true
    }
    
    public init<N: BinaryFloatingPoint & LosslessStringConvertible>(numberValues: [(N, N)]) {
        self.points = numberValues.map{(String($0.0), Double($0.1))}
        self.valuesGiven = true
    }
    
    public func onlyPoints() -> [Double] {
        return self.points.map{$0.1}
    }
    
    public var isEmpty: Bool {
        return onlyPoints().isEmpty
    }
}
