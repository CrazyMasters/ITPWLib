//
//  AnimatedGradient.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 12.04.2022.
//

import SwiftUI
/*
 animated gradient, good for placehodlers and such, supports dark/light schemes
 */
struct AnimatedGradient: View{
    @State private var animateGradient = false
    @Environment(\.colorScheme) private var colorScheme
    let light = [Color.white, Color(.sRGB, red: 0.5, green: 1, blue: 1, opacity: 1)]
    let dark = [Color.black, Color(.sRGB, red: 0.28, green: 0.3, blue: 0.3, opacity: 1)]
    var body: some View{
        LinearGradient(colors: colorScheme == .dark ? dark : light, startPoint: .topLeading, endPoint: .bottomTrailing)
            .hueRotation(.degrees(animateGradient ? 180 : 0))
            .ignoresSafeArea()
//            .blur(radius: 1)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
    }
}

struct AnimatedGradient_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGradient()
    }
}
