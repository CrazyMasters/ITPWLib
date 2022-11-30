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

    @State private var image = false

    @State private var value: Double = 30

    init(){
        URLCache.shared.removeAllCachedResponses()
    }
    var body: some View {
        VStack {
            CSlider(minValue: 10, maxValue: 1000, value: $value, step: 10, background: .gray, foreground: .red, withAnimation: true, slider: VStack{
                Rectangle().fill(Color.green).frame(width: 30, height: 10)
            })
            Text("slider value: \(value)")
        }
        .padding(.horizontal)
        
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
                        TechnicalAlertManager.shared.tryCreateAlert(.test)
                    }
               
            }
            AsyncImage(url: image ? "https://www.google.com/imgres?imgurl=https%3A%2F%2Fimages.squarespace-cdn.com%2Fcontent%2Fv1%2F52428a0ae4b0c4a5c2a2cede%2F1571057422934-PY8AG0WLM5DJ0PAYAPGN%2Fswiftui-animation-project.png%3Fformat%3D1000w&imgrefurl=https%3A%2F%2Fwww.ioscreator.com%2Ftutorials%2Fswiftui-animation-tutorial&tbnid=TgymFdpXyTP6fM&vet=12ahUKEwjM6qH4qsn6AhVPx4sKHYknB8EQMygPegUIARDhAQ..i&docid=sLLrg30sRaFivM&w=1000&h=716&q=swiftui%20animation%20in%20%20windowgroup&client=safari&ved=2ahUKEwjM6qH4qsn6AhVPx4sKHYknB8EQMygPegUIARDhAQ" : "data:image/jpeg;base64,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", contentMode: .fill)
                
                .frame(width: 80, height: 150)
                .background(Color.blue)
                .cornerRadius(10)
                
                .loading(isActive: loading)
                .onTapGesture {
                    image.toggle()
                    print("yeah")
                }
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
