//
//  View Extensions.swift
//  ITPWLib
//
//  Created by Permyakov Vladislav on 28.03.2022.
//

import Foundation
import SwiftUI

public extension View{
    ///модификатор, который ставит активити индикатор сверху и дисаблит вью
    func loading(
        isActive: Bool) -> some View {
            ZStack{
                self
                    .blur(radius: isActive ? 1 : 0)
                    .disabled(isActive)
                if isActive{
                ProgressView()
                }
                    
            }
            
    }
}
