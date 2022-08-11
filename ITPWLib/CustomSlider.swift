//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by Maksim Guzeev on 08.07.2022.
//

import SwiftUI
import Foundation
///Кастомный слайдер, которому можно приделать любой дизайн
public struct CSlider<Content: View>: View {
    
    ///передаваемое туда-сюда значение
    @Binding private var value: Double
    
    ///ширина всего слайдера для вычисления
    @State private var sliderWidth: Double = 100
    ///внутреннее значение слайдера
    @State private var internalValue: Double
    ///максимально возможное значение слайдера
    private let maxValue: Double
    ///с каким шагом меняется значение
    private let step: Double
    ///минимально возможное значение слайдера
    private let minValue: Double
    
    ///половина ширины всего слайдера
    @State private var sliderHalfWidth: Double = 14
    ///высота слайдера
    @State private var sliderHeight: Double = 1
    ///цвет правой части линии
    private let background: Color
    ///цвет левой части линии
    private let foreground: Color
    
    ///координатный шаг слайдера
    private var stepCoord: Double {
        
        return sliderWidth/(maxValue-minValue)
    }
    
    ///анимировать ли изменение
    private let animate: Bool
    
    ///сам слайдер
    private let slider: Content
    
    public init(minValue: Double,
                maxValue: Double,
                value: Binding<Double>,
                step: Double = 0.1,
                background: Color = .gray,
                foreground: Color = .blue,
                withAnimation: Bool = false,
                slider: Content){
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
        self._value = value
        self._internalValue = State(initialValue: min(maxValue, max(minValue, value.wrappedValue)) - minValue)
        self.background = background
        self.foreground = foreground
        self.slider = slider
        self.animate = withAnimation
    }
    
  
    
    
    
    public var body: some View {
        ZStack(alignment: .leading) {
            background
                .frame(maxWidth: .infinity, maxHeight: 4)
                .background(GeometryReader{geo in
                    Color.clear
                        .onAppear {
                            sliderWidth = geo.size.width
                        }
                        .onChange(of: geo.size.width) { val in
                            sliderWidth = geo.size.width
                        }
                    
                })
                .padding(.horizontal, sliderHalfWidth)
                .background(background)
                .overlay(
                    foreground
                        .mask(HStack{
                            let values = maxValue - minValue
                            let coordStep = sliderWidth / values
                            Capsule()
                                .frame(width: (internalValue * coordStep) + sliderHalfWidth)
                            Spacer()
                        })
                )
                .clipShape(Capsule())
                .overlay(
                    ZStack{
                        GeometryReader{ geo in
                            Color.white.opacity(.ulpOfOne)
                                .simultaneousGesture(
                                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onChanged({ newValue in
                                        let values = (maxValue-minValue)
                                        let singlePercent = geo.size.width / 100
                                        let tappedPercent = (newValue.location.x / singlePercent) / 100
                                        let draggedOnValue = (values * tappedPercent) + minValue
                                        let remainderFromDivider = draggedOnValue.truncatingRemainder(dividingBy: step)
                                        let snappedValue = remainderFromDivider < step/2 ? (draggedOnValue - remainderFromDivider) : (draggedOnValue - remainderFromDivider) + step
                                        value = snappedValue
                                    })
                                )
                        }
                        .frame(height: sliderHeight)
                        
                    }
                )
            Color.red
                .frame(width: 1, height: sliderHeight)
                .foregroundColor(.black)
            
                .overlay(
                    slider
                        .background(GeometryReader{geo in
                            Color.clear
                                .onAppear {
                                    sliderHalfWidth = max((geo.size.width/2) - 1 , 1)
                                    sliderHeight = max(geo.size.height , 1)
                                }
                                .onChange(of: geo.size.width) { val in
                                    sliderHalfWidth = max((geo.size.width/2) - 1 , 1)
                                    sliderHeight = max(geo.size.height , 1)
                                }
                            
                        })
                )
            
                .offset(x: (stepCoord * internalValue) + sliderHalfWidth)
                .gesture(DragGesture(minimumDistance: 2, coordinateSpace: .local).onChanged({ newValue in
                    
                    if newValue.location.x >= sliderHalfWidth,
                       newValue.location.x <= sliderWidth + sliderHalfWidth {
                        let percent = (maxValue-minValue) / sliderWidth
                        let coord = (newValue.location.x-sliderHalfWidth) * percent
                        let znach = coord.rounded()
                        let remaining = znach.truncatingRemainder(dividingBy: step)
                        let closestValue = remaining < (step / 2) ? (znach - remaining) : ((znach - remaining) + step)
                        if animate{
                            withAnimation(.spring()) {
                                internalValue = closestValue
                                value = internalValue + minValue
                            }
                        }else{
                            internalValue = closestValue
                            value = internalValue + minValue
                        }
                        
                    }
                }))
                .onChange(of: value) { newValue in
                    if animate{
                        withAnimation(.spring()) {
                            internalValue = min(maxValue, max(minValue, value)) - minValue
                        }
                    }else{
                        internalValue = min(maxValue, max(minValue, value)) - minValue
                    }
                }
        }
    }
}
