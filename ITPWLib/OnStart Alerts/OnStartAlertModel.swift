//
//  OnStartAlertModel.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import Foundation
// MARK: - AlertModel
public struct AlertModel: Codable {
    static let testValue1 = AlertModel(type: 1, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    static let testValue2 = AlertModel(type: 2, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    static let testValue3 = AlertModel(type: 3, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    static let testValue4 = AlertModel(type: 4, title: "title", text: "please upadte awfaf wgere aqewfg wef ", img: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", buttons: [AlertButton.testValue, AlertButton.testValue2])
    private let type: Int
    public let title, text: String?
    public let img: String?
    public let buttons: [AlertButton]
    public var alertType: AlertType{
        return AlertType(rawValue: self.type)!
    }
    
}

// MARK: - Button
public struct AlertButton: Codable {
    static let testValue = AlertButton(title: "Button", action: "link:https://apps.apple.com/ru/app/slog/id1589235953", main: true)
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


public enum AlertType: Int, CaseIterable{
    
    case none = 0
    ///closes automatically
    case simple = 1
    ///small with buttons and not closable
    case simpleDialogClosable = 2
    ///small with buttons and button to close
    case simpleDialog = 3
    /// on full screen non closable
    case criticalDialog = 4
}
