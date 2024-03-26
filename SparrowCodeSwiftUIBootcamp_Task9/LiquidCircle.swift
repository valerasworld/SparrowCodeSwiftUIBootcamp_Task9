//
//  LiquidCircle.swift
//  SparrowCodeSwiftUIBootcamp_Task9
//
//  Created by Валерий Зазулин on 25.03.2024.
//

import SwiftUI
import SpriteKit

struct LiquidCircle: View {
    
    let centerWidth = UIScreen.main.bounds.width / 2
    let centerHeight = UIScreen.main.bounds.height / 2
    
    @State private var offset = CGSize(width: 0, height: 0)
    @State private var imageOffset = CGSize(width: 0, height: 0)
    
    var body: some View {
        
        let translation = sqrt(offset.width * offset.width + offset.height * offset.height)
        let centetPoint = CGPoint(x: centerWidth, y: centerHeight)
        
        let startRadius = min(60, 60 + findNumberInNormalisedRange(number: translation, lowestData: 0, highestData: 130, rangeMin: 0, rangeMax: 5))
        let endRadius = max(70, 170 - findNumberInNormalisedRange(number: translation, lowestData: 0, highestData: 129.5, rangeMin: 0, rangeMax: 100))
        
        let sunOpacity = findNumberInNormalisedRange(number: translation, lowestData: 40, highestData: 80, rangeMin: 0, rangeMax: 1)
        let cloudOpacity = findNumberInNormalisedRange(number: translation, lowestData: 40, highestData: 73, rangeMin: 1, rangeMax: 0)
        let cloudIconOpacity = findNumberInNormalisedRange(number: translation, lowestData: 70, highestData: 129, rangeMin: 0, rangeMax: 1)
        let cloudIconOffset = findNumberInNormalisedRange(number: translation, lowestData: 90, highestData: 129, rangeMin: 0, rangeMax: 7)
        
        let cireclesScale = findNumberInNormalisedRange(number: translation, lowestData: 0, highestData: 130, rangeMin: 0, rangeMax: 0.15)
        
        let grayToWhite = findNumberInNormalisedRange(number: translation, lowestData: 0, highestData: 114, rangeMin: 0.6, rangeMax: 1)
        
        ZStack {
            Rectangle()
                .foregroundStyle(.blue.gradient).ignoresSafeArea()
            Rectangle()
                .foregroundStyle(.black.gradient).opacity(cloudOpacity).ignoresSafeArea()
            
            SpriteView(scene: RainFall(), options: [.allowsTransparency])
                .opacity(cloudOpacity)
                .ignoresSafeArea()
            
            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [Color(red: grayToWhite, green: grayToWhite, blue: grayToWhite), .yellow],
                        center: .center,
                        startRadius: startRadius,
                        endRadius: endRadius
                    )
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .mask {
                    Canvas { context, size in
                        guard let firstCircle = context.resolveSymbol(id: 0),
                              let secondCircle = context.resolveSymbol(id: 1)
                        else { return }
                        
                        context.addFilter(.alphaThreshold(min: 0.35, color: .red))
                        context.addFilter(.blur(radius: 20))
                        
                        context.drawLayer { context2 in
                            context2.draw(firstCircle, at: centetPoint)
                            context2.draw(secondCircle, at: centetPoint)
                        }
                    } symbols: {
                        Circle()
                            .frame(width: 150, height: 100, alignment: .center)
                            .scaleEffect(
                                CGSize(
                                    width: max(1.0, 1.15 - cireclesScale),
                                    height: max(1.0, 1.15 - cireclesScale)
                                )
                            )
                            .tag(0)
                        
                        Circle()
                            .frame(width: 100, height: 100, alignment: .center)
                            .scaleEffect(
                                CGSize(
                                    width: max(1.0, 1.15 - cireclesScale),
                                    height: max(1.0, 1.15 - cireclesScale)
                                )
                            )
                            .offset(offset)
                            .tag(1)
                    }
                    .ignoresSafeArea()
                    
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.offset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.bouncy(duration: 0.8, extraBounce: 0.35)) {
                                offset = CGSize(width: 0, height: 0)
                            }
                        }
                )
                .overlay {
                    Image(systemName: "sun.max.fill")
                        .offset(offset)
                        .opacity(sunOpacity)
                    
                    Image(systemName: "cloud.rain.fill")
                        .opacity(cloudOpacity)
                    
                    Image(systemName: "cloud")
                        .foregroundStyle(.blue)
                        .offset(y: min(0, -4 + cloudIconOffset))
                        .opacity(cloudIconOpacity)
                }
                .foregroundStyle(Color.white)
                .font(.largeTitle)
                .ignoresSafeArea()
        }
    }
    
    func findNumberInNormalisedRange(number: CGFloat, lowestData: CGFloat, highestData: CGFloat, rangeMin: CGFloat, rangeMax: CGFloat) -> CGFloat {
        
        let normalisedNumber = (((number - lowestData) * (rangeMax - rangeMin)) / (highestData - lowestData)) + rangeMin
        
        return normalisedNumber
    }
}

#Preview {
    LiquidCircle()
}

class RainFall: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        backgroundColor = .clear
        
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        addChild(node)
        
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

