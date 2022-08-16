//
//  TechnicalAlertModel.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 16.08.2022.
//

import Foundation

public struct TechnicalAlert: Codable{
    public static let test: Self = .init(id: 1, title: "Please update your app",
                                         messages: ["please update", "please more uopdate more upadet please please please"],
                                         images: ["https://leonardo.osnova.io/caf04c4d-3738-545d-9ff9-bbcd588fcdef/-/preview/500/-/format/webp/","https://leonardo.osnova.io/caf04c4d-3738-545d-9ff9-bbcd588fcdef/-/preview/500/-/format/webp/"],
                                         closable: false,
                                         buttons: [.test],
                                         required: false)
    public static let test2: Self = .init(id: 2, title: "Please update your app",
                                         messages: ["please update"],
                                         images: ["https://leonardo.osnova.io/caf04c4d-3738-545d-9ff9-bbcd588fcdef/-/preview/500/-/format/webp/"],
                                         closable: true,
                                          buttons: [.test, .test],
                                         required: false)
    public let id: Int
    public let title: String
    public let messages: [String]
    public let images: [String]
    public let closable: Bool
    public let buttons: [TechnicalAlertButton]
    public let required: Bool
}

public struct TechnicalAlertButton: Codable, Hashable, Equatable{
    public static let test: Self = .init(title: "Go to AppStore", url: "https://google.com")
    public let title: String
    public let url: String
}
