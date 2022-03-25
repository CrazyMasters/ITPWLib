//
//  OnStartAlertModel.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 25.03.2022.
//

import Foundation

// MARK: - AlertModel
internal struct AlertAPIModel: Codable {
    static let testValue0 = AlertAPIModel(type: 0, title: nil, text: nil, img: nil, buttons: [])
    static let testValue1 = AlertAPIModel(type: 1, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    static let testValue2 = AlertAPIModel(type: 2, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    static let testValue3 = AlertAPIModel(type: 3, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    static let testValue4 = AlertAPIModel(type: 4, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    public let type: Int
    public let title, text: String?
    public let img: String?
    public let buttons: [AlertButton]
    public var alertType: AlertType{
        return AlertType(rawValue: self.type)!
    }
    
}

// MARK: - Button
internal struct AlertButton: Codable {
    static let testValue = AlertButton(title: "Button", action: "link:https://www.apple.com", main: true)
    static let testValue2 = AlertButton(title: "Button2", action: "link:https://apps.apple.com/ru/app/slog/id1589235953", main: false)
    public let title, action: String
    public let main: Bool
    var link: URL? {
        if action.contains("link:"){
            let lin = action.replacingOccurrences(of: "link:", with: "")
            return URL(string: lin)
        }
        else{
            return nil
        }
    }
}


internal enum AlertType: Int, CaseIterable{
    
    case none = 0
    ///closes automatically
    case simple = 1
    ///small with buttons and closable
    case simpleDialogClosable = 2
    ///small with buttons and not closable
    case simpleDialog = 3
    /// on full screen non closable
    case criticalDialog = 4
}
