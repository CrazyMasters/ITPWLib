//
//  TechnicalAlertView.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 16.08.2022.
//

import SwiftUI

private extension Color{
    static let secondaryAccent = Color(hex: "E7B3B3")
    static let mainAccent = Color(hex: "FEB062")
    static let mainBackgroind = Color(hex: "2B2828")
    static let secondaryBackground = Color(hex: "575151")
    private init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}

internal struct TechnicalAlertView: View {
    let alert: TechnicalAlert
    let close: () -> ()
    @State private var selectedImage = 0
    var body: some View {
        ZStack{
            Color.white.opacity(0.7).ignoresSafeArea()
                .onTapGesture {if alert.closable{close()}}
        VStack{
            VStack(spacing: 10){
                Text(alert.title)
                    .font(.system(size: 25))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 15){
                    ForEach(alert.messages, id: \.self){message in
                        Text(message)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                    }
                    HStack{Spacer()}.frame(height: 0.1)
                }
                
                if alert.images.count > 0{
                    Rectangle().foregroundColor(.clear)
                        .aspectRatio(0.95, contentMode: .fit)
                        .overlay(
                            Group{
                                if alert.images.count > 1{
                                        TabView(selection: $selectedImage){
                                            ForEach(alert.images.indices, id: \.self){index in
                                                AsyncImage(url: alert.images[index], contentMode: .fill)
                                                    .cornerRadius(22)
                                                    .padding(5)
                                                    .tag(index)
                                            }
                                        }
                                        .tabViewStyle(.page(indexDisplayMode: .never))
                                }else if let image = alert.images.first{
                                    AsyncImage(url: image, contentMode: .fill)
                                        .cornerRadius(22)
                                        .padding(5)
                                }
                            }
                        )
                    if alert.images.count > 1{
                        HStack{
                            Spacer()
                            ForEach(alert.images.indices, id: \.self){index in
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(selectedImage == index ? .mainAccent : .secondaryBackground)
                            }
                            Spacer()
                        }
                    }
                    
                }
                ForEach(alert.buttons, id: \.self){button in
                    Button {
                        if let url = URL(string: button.url){
                        UIApplication.shared.open(url)
                            close()
                        }
                    } label: {
                        HStack{
                            Spacer()
                            Text(button.title)
                                .foregroundColor(.mainAccent)
                                .padding()
                            Spacer()
                        }
                        .background(Color.secondaryBackground.cornerRadius(16))
                    }
                }
                if alert.closable{
                    Button {
                        close()
                    } label: {
                        Text(NSLocalizedString("close", comment: ""))
                            .foregroundColor(.secondaryAccent)
                            .padding(1)
                            .overlay(VStack{
                                Spacer()
                                Rectangle().frame(height: 1).foregroundColor(.secondaryAccent)
                                    .padding(.horizontal, 2)
                            })
                    }

                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.mainBackgroind.cornerRadius(26))
        .padding(30)
        }
    }
}

struct TechnicalAlertView_Previews: PreviewProvider {
    static var previews: some View {
        
        TechnicalAlertView(alert: .test2, close: {})
            .background(Color.red.ignoresSafeArea())
    }
}
