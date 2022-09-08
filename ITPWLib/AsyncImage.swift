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
            if let cached = NetworkManager.imageCache.object(forKey: url as AnyObject) as? UIImage{
                DispatchQueue.main.async {
                    withAnimation {
                        self.image = nil
                        self.image = cached
                    }
                }
                return
            }
            let uiImage = try await NetworkManager().getImage(url: url)
            DispatchQueue.main.async {
                withAnimation {
                    self.image = nil
                    self.image = uiImage
                }
            }
            
        }
    }
    init(url: String){
        image = nil
        self.getImage(url: url)
    }
}
///async image that gets the image from url, saving in cache and doing it in async, supports ios 14
public struct AsyncImage: View {
    @StateObject private var vm: AsyncImageViewModel
    let contentMode: ContentMode
    let image: String
    public init(url: String, contentMode: ContentMode){
        self.contentMode = contentMode
        self.image = url
        self._vm = StateObject(wrappedValue: AsyncImageViewModel(url: url))
    }
    public var body: some View {
            Color.clear
                .overlay(Group{
                    if vm.image != nil{
                        Image(uiImage: vm.image!)
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                    }
                })
                .onChange(of: image) { newValue in
                    vm.image = nil
                    vm.getImage(url: image)
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

