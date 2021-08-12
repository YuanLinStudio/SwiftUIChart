//
//  IndicatorPoint.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

struct IndicatorPoint: View {
    
    var body: some View {
        ZStack {
            Circle()
                .fill(ChartColor.highlightColor)
                .shadow(radius: 10)
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
        }
        .frame(width: 14, height: 14)
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IndicatorPoint()
                .preferredColorScheme(.light)
            
            IndicatorPoint()
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 100, height: 100))
    }
}
