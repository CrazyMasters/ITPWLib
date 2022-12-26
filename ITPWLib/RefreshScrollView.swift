//
//  RefreshScrollView.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 12.04.2022.
//

import SwiftUI
import Combine

public struct RefreshScrollView<Content: View>: UIViewRepresentable{
    public func updateUIView(_ uiView: UIView, context: Context) {
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        for v in uiView.subviews where v.accessibilityIdentifier == "HOSTING" {
            v.removeFromSuperview()
        }
        guard let view = uiView as? UIScrollView else {return}

        let size = hostingController.view.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat.greatestFiniteMagnitude))
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.showsVerticalScrollIndicator = true
        view.contentSize = CGSize(width: view.frame.width, height: size.height)
        view.backgroundColor = .clear
        if !refreshing{
            view.refreshControl?.endRefreshing()
        }
    }
    @Binding var refreshing: Bool
    let onRefreshBegin: () -> ()
    let content: () -> Content
    public init(showing: Binding<Bool>, onRefresh: @escaping () -> (), @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.onRefreshBegin = onRefresh
        self._refreshing = showing
        
           
            
            
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(onRefreshBegin: onRefreshBegin, refreshing: self.$refreshing)
    }
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIScrollView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.refresh), for: .valueChanged)
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.accessibilityIdentifier = "HOSTING"
        let size = hostingController.view.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat.greatestFiniteMagnitude))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.addSubview(hostingController.view)
        view.showsVerticalScrollIndicator = true
        view.contentSize = hostingController.view.frame.size
        view.refreshControl = refreshControl
        view.contentSize = CGSize(width: view.frame.width, height: size.height)
        view.backgroundColor = .clear
        return view
    }
    
    public class Coordinator{
        let onRefreshBegin: () -> ()
        @Binding var refreshing: Bool
        init(onRefreshBegin: @escaping () -> (), refreshing: Binding<Bool>){
            self.onRefreshBegin = onRefreshBegin
            self._refreshing = refreshing
        }
        @objc func refresh(){
            if !refreshing{
                self.refreshing = true
            }
            onRefreshBegin()
        }
    }

}
