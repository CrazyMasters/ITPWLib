//
//  OnStartAlertViewModel.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 23.03.2022.
//

import SwiftUI

internal class OnStartViewModel: ObservableObject{
    @Published var image = UIImage()
    
     func getImage(url: String){
        Task{
            let uiImage = try await NetworkManager().getImage(url: url)
            DispatchQueue.main.async {
                self.image = uiImage
            }
            
        }
    }
}
