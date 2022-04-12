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
///async image that gets the image from url, saving in cache and doing it in async, supports ios 14
public struct AsyncImage: View {
    @StateObject private var vm: AsyncImageViewModel
    @State var contentMode: ContentMode
    public init(url: String, contentMode: ContentMode){
        self.contentMode = contentMode
        self._vm = StateObject(wrappedValue: AsyncImageViewModel(url: url))
    }
    public var body: some View {
        ZStack{
            AnimatedGradient()
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

