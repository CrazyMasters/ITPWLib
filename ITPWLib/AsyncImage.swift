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
                self.image = uiImage
            }
            
        }
    }
}
///async image that gets the image from url
public struct AsyncImage: View {
    @StateObject private var vm = AsyncImageViewModel()
    @State var url: String
    @State var contentMode: ContentMode
    public init(url: String, contentMode: ContentMode){
        self.url = url
        self.contentMode = contentMode
    }
    public var body: some View {
        Image(uiImage: vm.image ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .onAppear {
                if vm.image == nil{
                 vm.getImage(url: url)
                }
            }
        
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", contentMode: .fit)
    }
}
//
//
//extension Image{
//    init(url: String){
//        var image = UIImage()
//        self.init(uiImage: image)
//        Task{
//            let uiImage = try await NetworkManager().getImage(url: url)
//
//
//        }
//    }
//}
