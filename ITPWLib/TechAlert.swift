//
//  TechAlert.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 21.03.2022.
//
import UIKit
import WebKit
import PDFKit


public final class TechAlert{
    public init(){
        
    }
    /// создает окно поверх приложения с html кодом ошибки
    ///  Не появится, если релиз билд
    /// - Parameters:
    ///   - html: текст html
    public func HTMLAlertWindow(html: String) {
        
        DispatchQueue.main.async {
            let presentWindow: UIView?
            presentWindow = UIApplication.shared.keyWindow
#if DEBUG
            
#else
            return
#endif
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
//                                    activityVC.popoverPresentationController?.sourceView = button
                            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
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
            
            
            window.addSubview(container)
        }
    }
}

fileprivate extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}

