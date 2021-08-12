//
//  LineView.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/21.
//

import SwiftUI

public struct LineView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var data: ChartData
    
    public var title: String
    public var description: String?
    public var unit: String?
    public var style: ChartStyleSet
    
    public var height: CGFloat
    public var valueSpecifier: String
    
    public var sectionsCount: Int = 4
    
    @State private var showLegend = false
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var opacity: Double = 0
    @State private var currentDataNumber: Double = 0
    @State private var hideHorizontalLines: Bool = false
    
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
                height: CGFloat = 400,
                valueSpecifier: String? = "%.1f",
                sectionsCount: Int = 4) {
        
        self.data = ChartData(points: data)
        self.title = title
        self.description = description == "" ? nil : description
        self.unit = unit
        self.style = style
        self.height = height
        self.valueSpecifier = valueSpecifier!
        self.sectionsCount = sectionsCount
    }
    
    /// Variables and functions for Horizontal Grid Lines.
    struct Legend {
        var height: CGFloat
        var data: ChartData
        var sectionsCount: Int
        
        var stepHeight: CGFloat {
            return height / CGFloat(sectionsCount)
        }
        
        var min: CGFloat {
            return CGFloat(data.onlyPoints().min() ?? 0)
        }
        
        var max: CGFloat {
            return CGFloat(data.onlyPoints().max() ?? 0)
        }
        
        var labels: [CGFloat] {
            let step = (max - min) / CGFloat(sectionsCount)
            var sections = [CGFloat]()
            
            for index in 0 ... sectionsCount {
                sections.append(min + step * CGFloat(index))
            }
            return sections
        }
        
        func getLabel(ofSection index: Int) -> CGFloat {
            return labels[index]
        }
        
        func getPosition(ofSection index: Int) -> CGFloat {
            return -stepHeight * CGFloat(index)
        }
        
        func line(y: CGFloat, width: CGFloat) -> Path {
            var line = Path()
            line.move(to: CGPoint(x: 0, y: y))
            line.addLine(to: CGPoint(x: width, y: y))
            return line
        }
        
    }
    
    public var body: some View {
        
        VStack(alignment: .leading) {
            
            if data.points.count >= 2 {
                
                let lastValue = data.onlyPoints()[data.points.endIndex - 1]
                let secondLastValue = data.onlyPoints()[data.points.endIndex - 2]
                let difference = lastValue - secondLastValue
                
                HStack(alignment: .top) {
                    
                    Text("\(lastValue, specifier: valueSpecifier) \(unit ?? "")")
                        .font(.title)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        if let description = description {
                            Text(description)
                                .font(.callout)
                                .foregroundColor(style.descriptionColor)
                        }
                        
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
            
            if data.isEmpty {
                Spacer()
                Text("current-empty")
                    .font(.callout)
                    .foregroundColor(.secondary)
                Spacer()
            }
            else {
                GeometryReader { geometry in
                    
                    let geoFrame = geometry.frame(in: .local)
                    
                    let lineHeight = geoFrame.height - 10
                    let legendHeight = geoFrame.height - 40
                    
                    let legend = Legend(height: legendHeight, data: data, sectionsCount: sectionsCount)
                    
                    HStack(alignment: .bottom) {
                        ZStack(alignment: .trailing) {
                            ForEach(0 ... legend.sectionsCount, id: \.self) { index in
                                Text("\(legend.getLabel(ofSection: index), specifier: valueSpecifier)")
                                    .font(.caption)
                                    .foregroundColor(ChartColor.legendColor)
                                    .offset(x: 0, y: legend.getPosition(ofSection: index) + 7)
                            }
                        }
                        
                        GeometryReader { innerGeometry in
                            
                            let innerGeoFrame = innerGeometry.frame(in: .local)
                            
                            ZStack {
                                ForEach(0 ... legend.sectionsCount, id: \.self) { index in
                                    legend.line(y: innerGeoFrame.height, width: innerGeoFrame.width)
                                        .stroke(ChartColor.legendLineColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5, index == 0 ? 0 : 10]))
                                        .opacity((hideHorizontalLines && index != 0) ? 0 : 1)
                                        .offset(x: 0, y: legend.getPosition(ofSection: index))
                                        .animation(.easeOut)
                                }
                                
                                MagnifierRect(value: $currentValue, specifier: valueSpecifier, height: innerGeoFrame.height)
                                    .opacity(opacity)
                                    .offset(x: touchLocation.x - innerGeoFrame.width / 2, y: 0)
                                
                                Line(data: data,
                                     frame: .constant(CGRect(x: 0, y: 0, width: innerGeoFrame.width, height: lineHeight)),
                                     touchLocation: $touchLocation,
                                     showIndicator: $showIndicatorDot,
                                     minDataValue: .constant(nil),
                                     maxDataValue: .constant(nil)
                                )
                                .onAppear() { showLegend = true }
                                .onDisappear() { showLegend = false }
                            }
                            .gesture(DragGesture()
                                        .onChanged { value in
                                            DispatchQueue.main.async {
                                                touchLocation = value.location
                                                showIndicatorDot = true
                                                opacity = 1
                                                closestPoint = getClosestDataPoint(toPoint: value.location, width: innerGeoFrame.size.width, height: innerGeoFrame.size.height)
                                                hideHorizontalLines = true
                                            }
                                        }
                                        .onEnded { value in
                                            DispatchQueue.main.async {
                                                showIndicatorDot = false
                                                hideHorizontalLines = false
                                                opacity = 0
                                            }
                                        }
                            )
                        }
                    }
                }
            }
        }
        .animation(.easeIn)
        .transition(.slide)
        .padding()
        .frame(height: height)
        .navigationTitle(title)
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

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineView(data: [8, 23, 54, 32, 12, 37, 7, 23, 43], title: "Pressure", description: "Fingertip pressure", unit: "N")
                .preferredColorScheme(.light)
            
            LineView(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.118, 284.188], title: "Temperature", description: "Object temperature", unit: "℃")
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
