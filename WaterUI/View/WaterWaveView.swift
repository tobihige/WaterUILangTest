//
//  WaterWaveView.swift
//  WaterUI
//
//  Created by tobihige on 2023/10/01.
//

import SwiftUI

struct WaterWave: Shape {
    var progress: CGFloat
    var amplitude: CGFloat = 10
    var waveLength: CGFloat = 20
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let progressHeight = height * (1 - progress)
        let midWidth = width / 2
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        
        stride(from: 0, to: width + 5, by: 5).forEach { x in
            let relativeX = x / waveLength
            let normalizedLength = (x - midWidth) / midWidth
            let y = progressHeight + sin(phase + relativeX) * amplitude * normalizedLength
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: progressHeight))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: progressHeight))
        
        return path
    }
}

struct WaterWave3: Shape {
    var progress: CGFloat
    var amplitude: CGFloat = 10
    var waveLength: CGFloat = 20
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let progressHeight = height * (1 - progress)
        let midWidth = width / 2
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        
        stride(from: 0, to: width + 5, by: 5).forEach { x in
            let relativeX = x / waveLength
            let normalizedLength = (x - midWidth) / midWidth
            let y = progressHeight + sin(phase + relativeX) * amplitude * normalizedLength
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: progressHeight))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: progressHeight))
        
        return path
    }
}
