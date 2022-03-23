//
//  NetworkManager.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import Foundation
import SwiftUI
import Alamofire


internal class NetworkManager{
    private func getCachedImage(url: String) -> UIImage?{
        guard let Url = URL(string: url) else {return nil}
        guard let data = URLCache.shared.cachedResponse(for: URLRequest(url: Url))?.data else {return nil}
        if let cachedImage = UIImage(data: data) {
            return cachedImage
        }else{
            return nil
        }
    }
    
    private func saveCachedImage(url: String, image: UIImage){
        guard let Url = URL(string: url) else {return}
        let request = URLRequest(url: Url)
        let response = URLResponse(url: Url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let cachedData = CachedURLResponse(response: response, data: image.pngData()!)//.jpegData(compressionQuality: 0.7)!)
        
        URLCache.shared.storeCachedResponse(cachedData, for: request)
    }
    
    ///получаем uiimage из даты по юрлу
    func getImage(url: String) async throws -> UIImage{
        if let cached = getCachedImage(url: url){
            return cached
        }
        let request = AF.request("\(url)", method: .get)

            let data = try await request.serializingData().value
            if let image = UIImage(data: data){
                saveCachedImage(url: url, image: image)
                return image
            }else{
                print("no image at \(url)")
                return UIImage()
            }
          
    }
}
