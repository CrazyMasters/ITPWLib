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
        Text("Hello, world!")
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
