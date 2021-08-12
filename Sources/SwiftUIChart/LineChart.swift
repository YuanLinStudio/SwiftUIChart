//
//  LineChart.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

public struct LineChart: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var data: ChartData
    
    public var title: String
    public var description: String?
    public var unit: String?
    public var style: ChartStyleSet
    
    public var height: CGFloat
    public var valueSpecifier: String
    
    @State private var touchLocation: CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet {
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.SelectionChanged()
            }
        }
    }
    private var rateValue: Int?
    
    public init(data: [Double],
                title: String,
                description: String? = nil,
                unit: String? = nil,
                style: ChartStyleSet = ChartStyle.inherited,
                height: CGFloat = 200,
                valueSpecifier: String? = "%.1f") {
        
        self.data = ChartData(points: data)
        self.title = title
        self.description = description == "" ? nil : description
        self.unit = unit
        self.style = style
        self.height = height
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.title)
                                .bold()
                            
                            if let description = description {
                                Text(description)
                                    .font(.callout)
                                    .foregroundColor(style.descriptionColor)
                            }
                        }
                    }
                    
                    if data.points.count >= 2 {
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            
                            let lastValue = data.onlyPoints()[data.points.endIndex - 1]
                            let secondLastValue = data.onlyPoints()[data.points.endIndex - 2]
                            let difference = lastValue - secondLastValue
                            
                            Text("\(lastValue, specifier: valueSpecifier) \(unit ?? "")")
                                .fontWeight(.medium)
                            
                            if (lastValue > secondLastValue) {
                                Label("\(difference, specifier: valueSpecifier) \(unit ?? "")", systemImage: "arrow.up")
                                    .font(.caption)
                                    .foregroundColor(ChartColor.accentColor)
                            }
                            else if (lastValue < secondLastValue) {
                                Label("\(difference, specifier: valueSpecifier) \(unit ?? "")", systemImage: "arrow.down")
                                    .font(.caption)
                                    .foregroundColor(ChartColor.accentColor)
                            }
                        }
                    }
                }
                
                Spacer()
                
                if(showIndicatorDot) {
                    
                    Text("\(currentValue, specifier: valueSpecifier)")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            
            if data.isEmpty {
                Spacer()
                Text("current-empty")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
            else {
                GeometryReader { geometry in
                    
                    let geoFrame = geometry.frame(in: .local)
                    
                    Line(data: data,
                         frame: .constant(geoFrame),
                         touchLocation: $touchLocation,
                         showIndicator: $showIndicatorDot,
                         minDataValue: .constant(nil),
                         maxDataValue: .constant(nil)
                    )
                    .gesture(DragGesture()
                                .onChanged { value in
                                    DispatchQueue.main.async {
                                        touchLocation = value.location
                                        showIndicatorDot = true
                                        getClosestDataPoint(toPoint: value.location, width: geometry.size.width, height: geometry.size.height)
                                    }
                                }
                                .onEnded { value in
                                    showIndicatorDot = false
                                }
                    )
                }
            }
        }
        .animation(.easeIn)
        .transition(.slide)
        .padding(.vertical)
        .frame(height: height)
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
        let points = data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count - 1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index: Int = Int(round((toPoint.x) / stepWidth))
        if (index >= 0 && index < points.count) {
            currentValue = points[index]
            return CGPoint(x: CGFloat(index) * stepWidth, y: CGFloat(points[index]) * stepHeight)
        }
        return .zero
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChart(data: [8, 23, 54, 32, 12, 37, 7, 23, 43], title: "Pressure", description: "Fingertip pressure", unit: "N")
                .preferredColorScheme(.light)
            
            LineChart(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.118, 284.188], title: "Temperature", description: "Object temperature", unit: "℃")
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
