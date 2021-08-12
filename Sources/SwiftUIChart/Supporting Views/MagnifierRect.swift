//
//  MagnifierRect.swift
//  Fingertip Sensing
//
//  Created by 袁林 on 2020/11/13.
//

import SwiftUI

public struct MagnifierRect: View {
    
    @Binding var value: Double
    var specifier: String
    
    var width: CGFloat = 60
    var height: CGFloat = 280
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: width, height: height)
                .foregroundColor(colorScheme == .light ? ChartColor.backgroundColor : ChartColor.darkBackgroundColor)
                .shadow(radius: 20)
            //.blendMode(.multiply)
            
            Text("\(value, specifier: specifier)")
                .font(.headline)
                .fontWeight(.bold)
                .offset(x: 0, y: (-(height / 2) + 25))
                .foregroundColor(Color.primary)
        }
    }
}

struct MagnifierRect_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MagnifierRect(value: .constant(Double.pi), specifier: "%.3f")
                .preferredColorScheme(.light)
            
            MagnifierRect(value: .constant(Double.pi), specifier: "%.3f")
                .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
