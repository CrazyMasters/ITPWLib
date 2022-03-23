//
//  OnStartAlertView.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import SwiftUI

internal struct OnStartAlertView: View {
    @StateObject var vm = OnStartViewModel()
    var alert: AlertModel
    var close: () -> ()
    public var body: some View {
        ZStack{
            Color.clear.ignoresSafeArea().disabled(true)
            if alert.alertType == .criticalDialog{
                Color.white
                    .ignoresSafeArea()
            }
            VStack{
                if alert.title != nil{
                    Text(alert.title!)
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(5)
                }
                if alert.text != nil{
                    Text(alert.text!)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                }
                Image(uiImage: vm.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .padding()
                    .onAppear{
                        vm.getImage(url: alert.img ?? "")
                    }
                ForEach(alert.buttons, id:\.title){button in
                    Button {
                        print(button.action)
                    } label: {
                        HStack{
                            Spacer()
                            Text(button.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(10)
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(8)
                        .shadow(color: .black, radius: 1, x: 0, y: 0)
                    }

                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black, radius: alert.alertType != .criticalDialog ? 10 : 0, x: 0, y: 0)
            .padding(50)
            
        }
    }
}

struct OnStartAlertView_Previews: PreviewProvider {
    static var previews: some View {
        OnStartAlertView(alert: AlertModel.testValue2, close: {})
    }
}
