//
//  View Extensions.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 28.03.2022.
//

import Foundation
import SwiftUI

public extension View{
    ///модификатор, который ставит активити индикатор сверху и дисаблит вью
    func loading(
        isActive: Bool) -> some View {
            ZStack{
                self
                    .blur(radius: isActive ? 1 : 0)
                    .disabled(isActive)
                if isActive{
                ProgressView()
                }
                    
            }
            
    }
    ///кастомный алерт с текст филдом
    func textFieldAlert(
        isShowing: Binding<Bool>,
        title: String,
        confirm: @escaping (String) -> ()) -> some View {
            modifier(TextFieldAlert(isShowing: isShowing, confirm: confirm, title: title))
            
    }
}


fileprivate struct TextFieldAlert: ViewModifier {
    @Binding var isShowing: Bool
    @State var text: String = ""
    let confirm: (String) -> ()
    let title: String
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                content
                    .blur(radius: isShowing ? 1 : 0)
                    .disabled(isShowing)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                        
                    }
                VStack {
                    Text(self.title)
                        .foregroundColor(.gray)
                    TextField("...", text: self.$text)
                        .foregroundColor(.gray)
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                confirm(text)
                                self.isShowing.toggle()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }) {
                            Text(NSLocalizedString("confirm", comment: ""))
                            
                        }
                        .disabled(text.isEmpty)
                    }
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }) {
                            Text(NSLocalizedString("dismiss", comment: ""))
                        }
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(15)
                
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                
                .shadow(radius: 5)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}
