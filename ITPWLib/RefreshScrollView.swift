//
//  RefreshScrollView.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 12.04.2022.
//

import SwiftUI

fileprivate struct Indicator: View {
    
    var progress: Double
    var animating: Bool
 
    @State private var degree: Angle = .degrees(0)
    @State private var isRotated = false
    @Environment(\.colorScheme) private var colorScheme
    private var mainColor: Color{
        colorScheme == .dark ? Color.white : Color.black
    }
    public var animation: Animation = {
        Animation.linear
            .repeatForever(autoreverses: false)
            .speed(0.3)
        
    }()
    
    //графические свойсвтва лоадера
    let lineCount: Int = 8
    let lineWidth: CGFloat = 8.6
    let lineHeight: CGFloat = 3
    let spaceModifier: CGFloat = 2.2
    
    func opacity(line: Int) -> Double{
        let index: Double = Double(lineCount - line)
        let step: Double = Double(1)/Double(lineCount)
        return (step * index) + 0.1
    }
    func rotation(line: Int) -> Double{
        let index: Double = Double(line + 1)
        let step: Double = Double(360)/Double(lineCount)
        return step * index
    }
    func shouldShow(line: Int) -> Double{
        let index: Double = Double(line + 1)
        let percent: Double = Double(100/lineCount) * Double(index)
        if animating, progress == 0.0 {
            return 1
        }else{
            return percent > (progress*100) ? 0 : 1
        }
    }
    var body: some View {
        ZStack{
            indicator
                .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
                .animation(animation, value: isRotated)
                .onAppear {
                    withAnimation {
                        isRotated = true
                    }
                }
                .opacity(animating ? 1 : 0)
            
            indicator.opacity(animating ? 0 : 1)
            
        }
    }
    private var indicator: some View{
        ZStack{
            ForEach(0..<lineCount, id: \.self){lin in
                HStack{
                    Spacer()
                        .frame(width: lineWidth*spaceModifier, height: lineHeight)
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: lineWidth, height: lineHeight)
                        .foregroundColor(mainColor.opacity(opacity(line: lin)))
                        .opacity(shouldShow(line: lin))
                }
                .rotationEffect(.degrees(rotation(line: lin)) )
            }
        }
        .rotationEffect(.degrees(-45))
    }
}


 ///Custom refreshable scroll view that works in ios 14
///struct ContentView: View {
///    @State private var verticalOffset: CGFloat = 0.0
///    @State private var loading = false
///    var body: some View {
///        VStack{
///            RefreshScrollView(showing: $loading, todo: {
///                Task{
///                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
///                        withAnimation {
///                            loading = false
///                        }
///
///                    }
///                }
///            }){
///                ForEach(0..<100){cu in
///                    Text("\(cu)")
///                }
///            }
///        }
///    }
///}
public struct RefreshScrollView<T: View>: View {
    @State var offset = 0.0
    @Binding var lock: Bool
    
    private let maxOffset: CGFloat = 60
    let content: T
    let onRefresh: () -> ()
    
    public init(showing: Binding<Bool>, onRefresh: @escaping () -> (), @ViewBuilder content: () -> T) {
        self.content = content()
        self._lock = showing
        self.onRefresh = onRefresh
    }
    
    public var body: some View {
        //zstack that has our scroll content and Refresh indicator on top, so it wouldn't interfere with scrollview geometry readers
        ZStack{
            GeometryReader { outsideProxy in
                ScrollView {
                    ZStack {
                        GeometryReader { insideProxy in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: [(outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY)])
                                .padding(.top, lock ? maxOffset : 0)
                        }
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(height: maxOffset)
                             
                            VStack {
                                self.content
                            }
                            .offset(x: 0, y: lock ? 0 : (-maxOffset) + offset)
                            .padding(.bottom, -maxOffset)
                        }
                    }
                }
                .overlay(Color.black.opacity(lock ? 0.000001 : 0))
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                withAnimation {
                    if value[0] < 0, !lock{
                        self.offset = abs(value[0])
                        if self.offset > maxOffset{
                            self.lock = true
                            onRefresh()
                        }
                    }else{
                        self.offset = 0
                    }
                }
                .removeAll(where: <#T##(Self.Element) -> Bool#>)
            }
            //Refresh indicator
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Indicator(progress: offset/maxOffset, animating: lock)
                    }
                    Spacer()
                }
                .frame(height: lock ? maxOffset : offset)
                Spacer()
            }
        }
    }
    
    
}
fileprivate struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
