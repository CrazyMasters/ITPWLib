//
//  TechnicalAlertManager.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 16.08.2022.
//

import Foundation
import UIKit
import SwiftUI
public class TechnicalAlertManager{
    private init(){}
    public static let shared = TechnicalAlertManager()
    private var cache: [TechnicalAlert] = []
    
    public func tryCreateAlert(_ alert: TechnicalAlert){
        
        DispatchQueue.main.async {
            let presentWindow: UIView?
            presentWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = presentWindow else { return }
            //если алерт уже показан - умираем
            if window.subviews.contains(where: { (view) -> Bool in
                view.accessibilityIdentifier == "TechnicalAlert \(alert.id)"
            }) {return}
            
            
            let hostController = UIHostingController(rootView:
                                                        TechnicalAlertView(alert: alert, close: {
                self.closeAlert(alert.id)
            })
            )
            DispatchQueue.main.async {
                hostController.view.accessibilityIdentifier = "TechnicalAlert \(alert.id)"
                hostController.view.translatesAutoresizingMaskIntoConstraints = false
                
                
                window.addSubview(hostController.view)
                hostController.view.alpha = 0
                UIView.transition(with: hostController.view, duration: 0.5, options: .curveEaseInOut, animations: {
                    hostController.view.alpha = 1
                })
                NSLayoutConstraint.activate([
                    hostController.view.topAnchor.constraint(equalTo: window.topAnchor, constant: 0),
                    hostController.view.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0),
                    hostController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0),
                    hostController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
                ])
                hostController.view.backgroundColor = UIColor.clear
                
            }
        }
    }
    
    public func closeAlert(_ alertID: Int? = nil){
        DispatchQueue.main.async {
            let presentWindow: UIView?
            presentWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = presentWindow else { return }
            let id = alertID == nil ? "": " \(alertID!)"
            for child in window.subviews{
                if child.accessibilityIdentifier?.contains("TechnicalAlert\(id)") == true {
                    DispatchQueue.main.async {
                        UIView.transition(with: child, duration: 0.2, options: .curveEaseInOut, animations: {
                            child.alpha = 0
                        }) { _ in
                            child.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
}
