//
//  ContentView.swift
//  ITPWLibExamples
//
//  Created by Permyakov Vladislav on 21.03.2022.
//

import SwiftUI
import ITPWLib

struct ContentView: View {
    @State private var loading = false
    @State private var alert = false
    @State private var showingLoading = false
    @State private var value: Double = 30
    init(){
        URLCache.shared.removeAllCachedResponses()
    }
    var body: some View {
        CSlider(minValue: 30, maxValue: 100, value: $value, step: 10, background: .gray, foreground: .red, withAnimation: true, slider: VStack{
            Rectangle().fill(Color.green).frame(width: 30, height: 10)
        })
        RefreshScrollView(showing: $showingLoading, onRefresh: {
            print("reload")
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                withAnimation {
                    self.showingLoading = false
                }
            }
        }) {
            Text("TEST HTML Alert")
                .padding()
                .onTapGesture {
                    TechAlert().HTMLAlertWindow(html: """
    <!DOCTYPE html>
    <html>
    <head>
    <title>Page Title</title>
    </head>
    <body>

    <h1>My First Heading</h1>
    <p>My first paragraph.</p>

    </body>
    </html>

    """)
            }
            Button {
                print("test tap")
                
            } label: {
                HStack{
                    Spacer()
                    Text("rarwar awf awfRGESFAEF  raa")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.gray)
                .cornerRadius(15)
                .padding()
            }
            
//            CSlider(minValue: 0, maxValue: 100, value: $value, step: 1, sliderColor: .red, background: .gray, foreground: .red, slider: VStack{
//                Capsule().fill(Color.green).frame(width: 30, height: 15)
//            })
            HStack(){
                Spacer()
            }
            Text("Test swiftui Alert")
                .padding()
                .onTapGesture {
                    TechAlert().createAlert(text: """
akwfnijsang ajgndgni e  h r hnten tn rtn rbf b wrt nr n
etn et
 joet et
y jetn tnejt
n etn
etne
e ynet
 yne
 netoy
etyythmetyhkteklhjerjhkjrnhr
""")
//                    TechAlert().createAlert(text: "heh")
                }
            Text("textfield")
                .padding()
                .onTapGesture {
                    alert.toggle()
                }
            HStack{
                Text("type 1")
                    .padding()
                    .onTapGesture {
                        TechAlert().createTestTech(code: 1)
                    }
                Text("type 2")
                    .padding()
                    .onTapGesture {
                        TechAlert().createTestTech(code: 2)
                    }
                Text("type 3")
                    .padding()
                    .onTapGesture {
                        TechAlert().createTestTech(code: 3)
                    }
                Text("type 4")
                    .padding()
                    .onTapGesture {
                        TechAlert().createTestTech(code: 4)
                    }
            }
            AsyncImage(url: "http://dev1.itpw.ru:8005/media/nomenclatures/%D0%9D%D0%B0%D0%B1%D0%BE%D1%80%20%D1%82%D0%BE%D1%80%D1%86%D0%B5%D0%B2%D1%8B%D1%85%20%D0%B3%D0%BE%D0%BB%D0%BE%D0%B2%D0%BE%D0%BA%201/2%22%2C%20%D0%B1%D0%B8%D1%82%20%D0%B8%20%D0%B0%D0%BA%D1%81%D0%B5%D1%81%D1%81%D1%83%D0%B0%D1%80%D0%BE%D0%B2%20%D0%B2%20%D0%BA%D0%B5%D0%B9%D1%81%D0%B5%2C%2037%20%D0%BF%D1%80%D0%B5%D0%B4%D0%BC%D0%B5%D1%82%D0%BE%D0%B2%20NPI/photos/nabor_37_instrumentov_npi.png", contentMode: .fill)
                
                .frame(width: 80, height: 150)
                .background(Color.blue)
                .cornerRadius(10)
                
                .loading(isActive: loading)
            HStack{
                Text("Category")
                    .font(.title2)
                Spacer()
                AsyncImage(url: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", contentMode: .fit)
                    .cornerRadius(15)
                    .frame(height: 80)
                    .background(Color.red)
    //                .frame(height: 80)
                   
            }
            
            .padding(10)
            .background(Color.gray)
            .cornerRadius(10)
            .padding(.horizontal)
            Button {
                withAnimation {
                    loading.toggle()
                }
                
            } label: {
                HStack{
                    Spacer()
                    Text("Toggle loading")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.gray)
                .cornerRadius(15)
                .padding()
            }
            
            Spacer()
        }
//        .background(Color.whi.ignoresSafeArea())
        .textFieldAlert(isShowing: $alert, title: "title") { output in
            print(output)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
