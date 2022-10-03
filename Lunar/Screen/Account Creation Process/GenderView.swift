//
//  GenderView.swift
//  Lunar
//
//  Created by Jacob Lucas on 2/20/22.
//

import SwiftUI

struct GenderView: View {
    var genders = ["Male", "Female", "Non-binary", "Other"]
    @Binding var selectedGender: String
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text("SELECT YOUR GENDER")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                HStack(spacing: 5) {
                    Text("My gender is")
                        .font(.system(size: 18))
                    Text("\(selectedGender)")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                }
            }
            VStack {
                Spacer()
                Picker("Please choose a color", selection: $selectedGender) {
                    ForEach(genders, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
    }
}

struct GenderView_Previews: PreviewProvider {
    @State static var gender = "Male"
    static var previews: some View {
        GenderView(selectedGender: $gender)
    }
}
