//
//  RefreshScrollView.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 12.04.2022.
//

import SwiftUI

fileprivate struct Indicator: View {
    @State private var isRotated = false
    private var animation: Animation {
        Animation.linear
            .repeatForever(autoreverses: false)
            .speed(0.5)
        
    }
    let lineCount: Int = 8
    var opacityStep: Double{
        return Double(1/lineCount)
    }
    var rotateStep: Double{
        return Double(360/lineCount)
    }
    func opacity(line: Int) -> Double{
        let index: Double = Double(line + 1)
        let step: Double = Double(1)/Double(lineCount)
        return step * index
    }
    func rotation(line: Int) -> Double{
        let index: Double = Double(line + 1)
        let step: Double = Double(360)/Double(lineCount)
        return step * index
    }
    var body: some View {
        ZStack{
            ForEach(0..<lineCount, id: \.self){lin in
                HStack{
                    Spacer()
                        .frame(width: 13, height: 2)
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 6, height: 2)
                        .foregroundColor(.black.opacity(opacity(line: lin)))
                }
                .rotationEffect(.degrees(rotation(line: lin)) )
            }
        }
        .opacity(0.8)
        .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
        .animation(animation, value: isRotated)
        .onAppear {
            withAnimation {
                isRotated = true
            }
            
        }
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
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Indicator()
                            .frame(height: lock ? maxOffset : offset)
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                .opacity(lock ? 1 : offset/maxOffset)
                .frame(height: maxOffset)
                Spacer()
            }
            GeometryReader { outsideProxy in
                
                ScrollView {
//                    Spacer()
//                        .frame(height: lock ? maxOffset : 1)
                    ZStack {
                        GeometryReader { insideProxy in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: [(outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY)])
                                .padding(.top, lock ? maxOffset : 0)
                        }
                        VStack {
                            Color.clear
                                .frame(height: lock ? maxOffset : offset)
                            self.content
                        }
                    }
                }
                
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                withAnimation {
                    if value[0] < 0, !lock{
                        self.offset = abs(value[0])/2
                        if self.offset > maxOffset{
                            self.lock = true
                            onRefresh()
                        }
                    }else{
                        self.offset = 0
                    }
                }
                
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
