//
//  AlertView.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import SwiftUI

///показывает сверху на пару секунд текст, масштабируется
internal struct AlertView: View {
    @State var text: String
    var close: ()->()
    private func removeView(){
//        #warning("переделать исчезновение вью через бул")
        withAnimation {
            offset = -1000.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                close()
            }
        }
    }
    @State private var offset = -1000.0
    
    public var body: some View {
        VStack{
            Text(text)
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .multilineTextAlignment(.center)
                .cornerRadius(10)
                .shadow(color: .black, radius: 5, x: 0, y: 0)
                .offset(x: 0, y: offset)
                .animation(.spring())
                .onTapGesture {
//                   removeView()
                }
            Spacer()
        }
        .onAppear(perform: {
            withAnimation {
                offset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                removeView()
            }
        })
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(text: "BigText", close: {print("cuck")})
    }
}
