//
//  AgeView.swift
//  Lunar
//
//  Created by Jacob Lucas on 3/6/22.
//

import SwiftUI

struct AgeView: View {
    
    @Binding var age: String
    
    var body: some View {
        VStack(spacing: 14) {
            Text("ENTER YOUR AGE")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 40)
                    .foregroundColor(Color(.systemGray6))
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
            }
            .frame(width: UIScreen.main.bounds.width - 320)
        }
        .frame(width: UIScreen.main.bounds.width - 50)
    }
}
