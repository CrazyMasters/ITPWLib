//
//  ContentView.swift
//  ITPWLibExamples
//
//  Created by Permyakov Vladislav on 21.03.2022.
//

import SwiftUI
import ITPWLib

struct ContentView: View {
    var body: some View {
        VStack {
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
            AsyncImage(url: "http://dev1.itpw.ru:8004/media/defaults/need_update.jpg", contentMode: .fill)
                .frame(width: 80, height: 20)
                .cornerRadius(10)
            Spacer()
        }
        .background(Color.red.ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
