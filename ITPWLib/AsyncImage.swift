//
//  AsyncImage.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import SwiftUI

internal class AsyncImageViewModel: ObservableObject{
    @Published var image = UIImage()
    func getImage(url: String){
        Task{
            let uiImage = try await NetworkManager().getImage(url: url)
            image = uiImage
        }
    }
}

public struct AsyncImage: View {
    @StateObject var vm = AsyncImageViewModel()
    @State var url: String
    public var body: some View {
        Image(uiImage: vm.image)
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .onTapGesture {
                vm.getImage(url: url)
            }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg")
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
