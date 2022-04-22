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
    init(){
        URLCache.shared.removeAllCachedResponses()
    }
    var body: some View {
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
            AsyncImage(url: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", contentMode: .fit)
                
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
                    .frame(maxHeight: 80)
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
