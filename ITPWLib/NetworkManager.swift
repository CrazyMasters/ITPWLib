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
    static var AlertHost = "https://fb14c25e-e7df-4fca-baef-90843943fca9.mock.pstmn.io/"
    enum APIError: Error {
        case detail(text: String)
        case authError
        case html(html: String)
    }
    
    /**
     Отправляет запрос и возвращает сериализованную модель
     
    
     
     
     - parameter url: `String` ссылка запроса.
     - parameter method: `HTTPMethod` for the `URLRequest`..
     - parameter params: `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by
     default.
     - parameter header: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default and adds token header inside the func
     - parameter encoder: `ParameterEncoding` to be used to encode the `parameters` value into the `URLRequest`.
     `URLEncoding.default` by default..
     - parameter noToken: `Bool` value if to send token with request or not, true(dont send token) by default.
     - returns: return T where T is Codable
     - warning: Throws `APIError`.
     
  
     do{
         let url = "\(APIManager.host)marketplace/nomenclature-properties/"
         let data = try await request(url: url, method: .get, params: ["nomenclature": material]) as [MaterialProperty]
         return data
     }catch APIError.detail(let text){
         throw APIError.detail(text: text)
     }
     
     
     */
    
    func request<T: Codable>(url: String, method: HTTPMethod, params: Parameters?, header: HTTPHeaders? = nil, encoder: ParameterEncoding = URLEncoding.default, noToken: Bool = true) async throws -> T{
        
        let headers: HTTPHeaders = header ?? []
        
        
        let request = AF.request(url,
                                 method: method,
                                 parameters: params,
                                 encoding: encoder,
                                 headers: headers).serializingDecodable(T.self)
        
        
        let response = await request.response
        guard (200...299).contains(response.response?.statusCode ?? 0) else {
            throw APIError.detail(text: "not 200")
            }
        
        
            //trying to get value out of it
            guard let value = response.value else {
                ///couldn't parse data but it was a succesful request
                if let data = response.data{
                    print(String(data: data, encoding: .utf8) as Any)
                }
                print("got data success but couldn't parse it to Model")
                throw APIError.detail(text: "bad_request")
                
            }
            
            print(String(data: response.data!, encoding: .utf8) as Any)
            return value
        
        
    }
    
    
    
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
    
    ///получаем uiimage из даты по юрлу
    func get_alerts(appID: String) async throws -> AlertAPIModel{
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {throw APIError.detail(text: "")}
        let params: Parameters = ["app_id" : appID, "app_version" : appVersion]
        let data = try await request(url: "\(NetworkManager.AlertHost)get_alert/", method: .get, params: params) as AlertAPIModel
        return data
          
    }
}
