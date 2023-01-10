//
//  AsyncImage.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import SwiftUI
import Combine
import Foundation

///async image that gets the image from url, saving in cache and doing it in async, supports ios 14
public struct AsyncImage: View {
    let contentMode: ContentMode
    let image: String
    public init(url: String, contentMode: ContentMode){
        self.contentMode = contentMode
        self.image = url
    }
    public var body: some View {
        GeometryReader{geo in
            Color.clear
                .overlay(Group{
                    if let url = URL(string: image){
                        AsynImage(url: url, placeholder: {Text(" ")}) .aspectRatio(contentMode: contentMode)
                            .id(image)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }
                })
                .allowsHitTesting(false)
        }
        
               
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGradient()
            .preferredColorScheme(.dark)
    }
}



class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    let url: URL

    init(url: URL) {
        self.url = url
        self.load()
    }

    deinit {
        cancel()
    }
    
    private var cancellable: AnyCancellable?

    func load() {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        let appToken = Bundle.main.object(forInfoDictionaryKey: "AppToken") as? String ?? ""
        request.httpMethod = "GET"
        request.addValue(appToken, forHTTPHeaderField: "AppToken")
        cancellable = session.dataTaskPublisher(for: request)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imag in
                if self?.image == nil{
                    withAnimation{
                        self?.image = imag
                    }
                }
                
            }
    }
        
        func cancel() {
            cancellable?.cancel()
        }
}

struct AsynImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        
    }
    
    var body: some View {
        content
            .transition(.opacity)
            .animation(.default, value: loader.url)
            
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .transition(.opacity)
            } else {
                placeholder
                    .transition(.opacity)
                   
            }
        }
        .animation(.default, value: loader.image)
    }
}
