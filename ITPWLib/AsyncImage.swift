//
//  AsyncImage.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import SwiftUI

internal class AsyncImageViewModel: ObservableObject{
    @Published var image: UIImage?
    func getImage(url: String){
        Task{
            let uiImage = try await NetworkManager().getImage(url: url)
            DispatchQueue.main.async {
                withAnimation {
                    self.image = uiImage
                }
            }
            
        }
    }
    init(url: String){
        self.getImage(url: url)
    }
}
///async image that gets the image from url
public struct AsyncImage: View {
    @StateObject private var vm: AsyncImageViewModel
    @State var contentMode: ContentMode
    public init(url: String, contentMode: ContentMode){
        self.contentMode = contentMode
        self._vm = StateObject(wrappedValue: AsyncImageViewModel(url: url))
    }
    public var body: some View {
        
        if vm.image == nil{
            AnimatedGradient()
        }else{
            Image(uiImage: vm.image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: contentMode)
        }
        
        
        
        
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
//        AsyncImage(url: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", contentMode: .fit)
        AnimatedGradient()
            .preferredColorScheme(.dark)
    }
}

private struct AnimatedGradient: View{
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
