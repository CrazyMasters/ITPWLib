//
//  ITPWLibExamplesApp.swift
//  ITPWLibExamples
//
//  Created by Permyakov Vladislav on 21.03.2022.
//

import SwiftUI
import ITPWLib

@main
struct ITPWLibExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    TechAlert().checkOnStartAlerts(appID: "123")
                }
        }
    }
}
