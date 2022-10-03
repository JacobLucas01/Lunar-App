//
//  AddNameView.swift
//  Lunar
//
//  Created by Jacob Lucas on 2/27/22.
//

import SwiftUI

struct AddNameView: View {
    
    @Binding var name: String
    @Binding var username: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("ENTER YOUR NAME")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 40)
                    .foregroundColor(Color(.systemGray6))
                TextField("Enter Name", text: $name)
                    .frame(width: UIScreen.main.bounds.width - 70)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 50)
    }
}

struct AddNameView_Previews: PreviewProvider {
    @State static var name = ""
    @State static var username = ""
    static var previews: some View {
        AddNameView(name: $name, username: $username)
    }
}
