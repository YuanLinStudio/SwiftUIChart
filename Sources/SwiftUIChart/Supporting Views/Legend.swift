//
//  Legend.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/21.
//

import SwiftUI

// DEPRECATED IN CURRENT USE.
/*
struct Legend: View {
    
    @ObservedObject var data: ChartData
    
    @Binding var frame: CGRect
    @Binding var hideHorizontalLines: Bool
    
    public var valueSpecifier: String = "%.2f"
    public var sectionsCount: Int = 4
    
    let padding: CGFloat = 3 /////////////////////

    var stepWidth: CGFloat {
        if data.points.count < 2 {
            return 0
        }
        return frame.width / CGFloat(data.points.count - 1)
    }
    
    var stepHeight: CGFloat {
        return frame.height / CGFloat(sectionsCount)
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
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                ForEach(0 ... sectionsCount, id: \.self) { index in
                    Text("\(getLabel(ofSection: index), specifier: valueSpecifier)")
                        .font(.caption)
                        .foregroundColor(ChartColor.legendColor)
                        .offset(x: 0, y: getOffsetPosition(ofSection: index))
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    ForEach(0 ... sectionsCount, id: \.self) { index in
                        line(width: geometry.frame(in: .local).width)
                            .stroke(ChartColor.legendLineColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5, index == 0 ? 0 : 10]))
                            .opacity((hideHorizontalLines && index != 0) ? 0 : 1)
                            .offset(x: 0, y: getPosition(ofSection: index))
                            .animation(.easeOut)
                    }
                }
            }
        }
        
        /*
        ZStack(alignment: .topLeading) {
            ForEach((0 ... sectionsCount), id: \.self) { section in
                HStack(alignment: .center) {
                    Text("\(getSection(ofSection: section), specifier: valueSpecifier)")
                        .offset(x: 0, y: getOffsetPosition(ofSection: section))
                        .foregroundColor(ChartColor.legendColor)
                        .font(.caption)
                    
                    line(ofSection: section, width: frame.width)
                        .stroke(ChartColor.legendLineColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5, section == 0 ? 0 : 10]))
                        .opacity((hideHorizontalLines && section != 0) ? 0 : 1)
                        .animation(.easeOut)
                        .clipped()
                }
            }
        }*/
    }
    
    func getLabel(ofSection index: Int) -> CGFloat {
        return labels[index]
    }
    
    func getPosition(ofSection index: Int) -> CGFloat {
        return frame.height - stepHeight * CGFloat(index)
    }
    
    func getOffsetPosition(ofSection index: Int) -> CGFloat {
        return getPosition(ofSection: index) - frame.height / 2
    }
    
    func line(width: CGFloat) -> Path {
        var line = Path()
        line.move(to: CGPoint(x: 0, y: 0))
        line.addLine(to: CGPoint(x: width, y: 0))
        return line
    }
}

struct Legend_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Legend(data: ChartData(points: [0.2, 0.4, 1.4, 4.5]), frame: .constant(CGRect(x: 0, y: 0, width: 320, height: 200)), hideHorizontalLines: .constant(false))
                .frame(width: 320, height: 200)
                .preferredColorScheme(.light)
            Legend(data: ChartData(points: [0.2, 0.4, -1.4, 4.5, 2.0]), frame: .constant(CGRect(x: 0, y: 0, width: 320, height: 200)), hideHorizontalLines: .constant(false))
                .frame(width: 320, height: 200)
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
*/
