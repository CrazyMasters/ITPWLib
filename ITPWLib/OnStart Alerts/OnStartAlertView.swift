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
    @State var showing = false
    func startClosing(){
        withAnimation {
            showing = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            close()
        }
    }
    
//    init(alert: AlertModel, close: @escaping () -> ()){
//        self.alert = alert
//        self.close = close
//    }
    public var body: some View {
        ZStack{
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
                if alert.alertType != .simple{
                    ForEach(alert.buttons, id:\.title){button in
                        Button {
                            if let link = button.link{
                                UIApplication.shared.open(link)
                            }
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
                        }
                    }
                }
                if alert.alertType == .simpleDialogClosable{
                    Button {
                        startClosing()
                    } label: {
                        HStack{
                            Spacer()
                            Text(NSLocalizedString("close", comment: ""))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(10)
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(8)
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: alert.alertType != .criticalDialog ? .black : .clear, radius: 10, x: 0, y: 0)
            .padding(50)
            .offset(x: 0, y: showing ? 0 : -500)
        }
        .opacity(showing ? 1 : 0)
        .onAppear {
            withAnimation {
                showing = true
            }
            if alert.alertType == .simple{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.startClosing()
                }
            }
        }
        
    }
}

struct OnStartAlertView_Previews: PreviewProvider {
    static var previews: some View {
        OnStartAlertView(alert: AlertModel.testValue2, close: {})
    }
}
