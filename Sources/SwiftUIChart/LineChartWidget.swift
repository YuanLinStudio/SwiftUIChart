//
//  LineChartWidget.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

public struct LineChartWidget: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var data: ChartData
    
    public var title: String
    public var description: String?
    public var unit: String?
    public var style: ChartStyleSet
    
    public var size: CGSize
    public var dropShadow: Bool
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
    var frame = CGSize(width: 180, height: 120)
    private var rateValue: Int?
    
    public init(data: [Double],
                title: String,
                description: String? = nil,
                unit: String? = nil,
                style: ChartStyleSet = ChartStyle.inherited,
                size: CGSize? = ChartSize.large,
                dropShadow: Bool? = true,
                valueSpecifier: String? = "%.1f") {
        
        self.data = ChartData(points: data)
        self.title = title
        self.description = description == "" ? nil : description
        self.unit = unit
        self.style = style
        self.size = size!
        frame = CGSize(width: self.size.width, height: self.size.height / 2)
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .light ? ChartColor.backgroundColor : ChartColor.darkBackgroundColor)
                .frame(width: frame.width, height: 240, alignment: .center)
                .shadow(radius: dropShadow ? 10 : 0)
            
            VStack(alignment: .leading) {
                ZStack {
                    if(!self.showIndicatorDot) {
                        VStack(alignment: .leading, spacing: 10) {
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
                                Spacer()
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
                        .transition(.opacity)
                        .padding()
                    }
                    else {
                        HStack {
                            Spacer()
                            Text("\(currentValue, specifier: valueSpecifier)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        .padding(.vertical, 21.5)  // adjust this to make the Line View fixed
                        .transition(.scale(scale: 0, anchor: .bottom))
                    }
                }
                .animation(.easeIn)
                
                Spacer()
                
                GeometryReader { geometry in
                    Line(data: data,
                         frame: .constant(geometry.frame(in: .local)),
                         touchLocation: $touchLocation,
                         showIndicator: $showIndicatorDot,
                         minDataValue: .constant(nil),
                         maxDataValue: .constant(nil)
                    )
                    .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
                .frame(width: frame.width, height: frame.height + 30)
                .gesture(DragGesture()
                            .onChanged { value in
                                touchLocation = value.location
                                showIndicatorDot = true
                                getClosestDataPoint(toPoint: value.location, width: frame.width, height: frame.height)
                            }
                            .onEnded { value in
                                self.showIndicatorDot = false
                            }
                )
            }
            .frame(width: size.width, height: size.height)
        }
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count - 1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(round((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentValue = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

struct LineChartWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartWidget(data: [8, 23, 54, 32, 12, 37, 7, 23, 43], title: "pressure", description: "Fingertip pressure", unit: "N", size: ChartSize.large)
                .preferredColorScheme(.light)
            
            LineChartWidget(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.118, 284.188], title: "temperature", description: "Object temperature", unit: "℃", size: ChartSize.large)
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
