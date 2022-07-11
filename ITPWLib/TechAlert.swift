//
//  TechAlert.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 21.03.2022.
//
import UIKit
import WebKit
import PDFKit
import SwiftUI

///Технические алерты для использования в приложении
public final class TechAlert{
    public init(){
        
    }
    
    ///Алерт сверху экрана, с текстом
    public func createAlert(text: String) {
        #warning("duration")
        DispatchQueue.main.async {
            
            //получаем окно
            let presentWindow: UIView?
            presentWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = presentWindow else { return }
            //если алерт уже показан - умираем
            if window.subviews.contains(where: { (view) -> Bool in
                view.accessibilityIdentifier == text
            }) {return}
            let hostController = UIHostingController(rootView: AlertView(text: text, close: {
                for child in window.subviews{
                    if child.accessibilityIdentifier == text{
                        child.removeFromSuperview()
                    }
                }
            }))
            hostController.view.accessibilityIdentifier = text
            hostController.view.translatesAutoresizingMaskIntoConstraints = false
            
            window.addSubview(hostController.view)
            
            NSLayoutConstraint.activate([
                hostController.view.topAnchor.constraint(equalTo: window.topAnchor, constant: 0),
                hostController.view.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: 0),
                hostController.view.widthAnchor.constraint(lessThanOrEqualTo: window.widthAnchor, constant: 0),
            ])
            hostController.view.backgroundColor = UIColor.clear
            
        }
    }
    ///создает один из информационных алертов о системе
    private func createOnStartAlert(alert: AlertAPIModel){
        DispatchQueue.main.async {
            //получаем окно
            let presentWindow: UIView?
            presentWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = presentWindow else { return }
            //если нулевой алерт, то убираем уже существующий по идентификатору
            if alert.alertType == .none{
                for child in window.subviews{
                    if child.accessibilityIdentifier == "pop"{
                        child.removeFromSuperview()
                    }
                }
                return
            }
            //если алерт уже показан - умираем
            if window.subviews.contains(where: { (view) -> Bool in
                view.accessibilityIdentifier == "pop"
            }) {return}
            
            //создаем контроллер, передаем тип алерта и функцию для закрытия
            let hostController = UIHostingController(rootView: OnStartAlertView(alert: alert, close: {
                for child in window.subviews{
                    if child.accessibilityIdentifier == "pop"{
                        child.removeFromSuperview()
                    }
                }
            }))
            
            //даем идентификатор окну алерта
            hostController.view.accessibilityIdentifier = "pop"
            hostController.view.translatesAutoresizingMaskIntoConstraints = false
            
            window.addSubview(hostController.view)
            
            NSLayoutConstraint.activate([
                hostController.view.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: 0),
                hostController.view.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: 0),
                hostController.view.widthAnchor.constraint(equalTo: window.widthAnchor, constant: 0),
                hostController.view.heightAnchor.constraint(equalTo: window.heightAnchor, constant: 0),
            ])
            hostController.view.backgroundColor = UIColor.clear
            
        }
    }
    ///проверить с сервера, нужно ли показать какой-либо алерт, например об outdated app version или тех работы
    public func checkOnStartAlerts(appID: String){
        Task{
            let alert = try await NetworkManager().get_alerts(appID: appID)
            createOnStartAlert(alert: alert)
        }
    }
    
    public func createTestTech(code: Int) {
        let alert: AlertAPIModel
        switch code {
        case 0:
            alert = AlertAPIModel.testValue0
        case 1:
            alert = AlertAPIModel.testValue1
        case 2:
            alert = AlertAPIModel.testValue2
        case 3:
            alert = AlertAPIModel.testValue3
        case 4:
            alert = AlertAPIModel.testValue4
        default:
            alert = AlertAPIModel.testValue4
        }
        createOnStartAlert(alert: alert)
    }
    
    /// создает окно поверх приложения с html кодом ошибки
    ///  Не появится, если релиз билд
    /// - Parameters:
    ///   - html: текст html
    public func HTMLAlertWindow(html: String) {
        
        DispatchQueue.main.async {
            let presentWindow: UIView?
            presentWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = presentWindow else { return }
            //if this alert exists - we go away
            if window.subviews.contains(where: { (view) -> Bool in
                view.accessibilityIdentifier == html
            }) {return}
            
            
            let size = CGSize(width: window.bounds.width, height: window.bounds.height)
            
            let container = WKWebView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
            container.accessibilityIdentifier = html
            container.layer.cornerRadius = 15
            container.loadHTMLString(html, baseURL: nil)
            
            
            let buttonClose = UIButton()
            buttonClose.setTitle("CLOSE", for: .normal)
            buttonClose.setTitleColor(UIColor.systemBlue, for: .normal)
            buttonClose.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.4), for: .highlighted)
            buttonClose.backgroundColor = .red
            buttonClose.layer.cornerRadius = 10
            buttonClose.addAction {
                
                container.removeFromSuperview()
                
            }
            buttonClose.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(buttonClose)
            NSLayoutConstraint.activate([
                buttonClose.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 5),
                buttonClose.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
                buttonClose.widthAnchor.constraint(equalToConstant: 100),
                buttonClose.heightAnchor.constraint(equalToConstant: 30)
            ])
            let button = UIButton()
            button.setTitle("share", for: .normal)
            button.setTitleColor(UIColor.systemBlue, for: .normal)
            button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.4), for: .highlighted)
            button.backgroundColor = .red
            button.layer.cornerRadius = 10
            button.addAction {
                
//                container.removeFromSuperview()
                Task{
                    container.createPDF { result in
                        switch result{
                        case .success(let data):
                            let objectsToShare = [data]
                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            if let rootController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
                                    var currentController: UIViewController! = rootController
                                    while( currentController.presentedViewController != nil ) {
                                        currentController = currentController.presentedViewController
                                    }
                                currentController.present(activityVC, animated: true, completion: nil)
                                }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: buttonClose.safeAreaLayoutGuide.bottomAnchor, constant: 5),
                button.trailingAnchor.constraint(equalTo: buttonClose.trailingAnchor, constant: 0),
                button.widthAnchor.constraint(equalToConstant: 100),
                button.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            
#if DEBUG
            window.addSubview(container)
#endif
            
        }
    }
}

fileprivate extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}


