//
//  TechnicalAlertModel.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 16.08.2022.
//

import Foundation
import SwiftUI


public struct AlertColor: Codable, Hashable, Equatable{
    public let light: String
    public let dark: String
    public var color: Color{
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: self.dark)) : UIColor(Color(hex: self.light))
        }
        )
    }
}
public struct AlertText: Codable, Hashable, Equatable{
    public static let test: Self = .init(body: "Text Text", color: .init(light: "E7B3B3", dark: "E7B3B3"))
    public let body: String
    public let color: AlertColor
}
public struct AlertButton: Codable, Hashable, Equatable{
    public static let test: Self = .init(title: .init(body: "Text Text", color: .init(light: "E7B3B3", dark: "E7B3B3")), url: "https://gooogle.com", backgroundColor: .init(light: "E7B3B3", dark: "E7B3B3"))
    public let title: AlertText
    public let url: String
    public let backgroundColor: AlertColor
}
public struct TechnicalAlert: Codable{
    
    public static let test: Self = .init(id: 1,
                                         title: .test,
                                         messages: [],
                                         images: ["https://leonardo.osnova.io/caf04c4d-3738-545d-9ff9-bbcd588fcdef/-/preview/500/-/format/webp/","https://leonardo.osnova.io/caf04c4d-3738-545d-9ff9-bbcd588fcdef/-/preview/500/-/format/webp/"],
                                         closable: true,
                                         close_button_color: .init(light: "FEB062", dark: "FEB062"),
                                         buttons: [.test],
                                         required: false,
                                         image_indicator_accent_color: .init(light: "FEB062", dark: "FEB062"),
                                         image_indicator_background_color: .init(light: "E7B3B3", dark: "E7B3B3"),
                                         backgroundColor: .init(light: "2B2828", dark: "2B2828"))
    public let id: Int
    public let title: AlertText
    public let messages: [AlertText]
    public let images: [String]
    public let closable: Bool
    public let close_button_color: AlertColor
    public let buttons: [AlertButton]
    public let required: Bool
    public let image_indicator_accent_color: AlertColor
    public let image_indicator_background_color: AlertColor
    public let backgroundColor: AlertColor
}


