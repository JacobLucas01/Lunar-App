//
//  MainView.swift
//  Lunar
//
//  Created by Jacob Lucas on 4/27/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
        ZStack {
            HStack {
                Button {
    
                } label: {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 38, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 17))
                        .foregroundColor(Color(.label))
                }
            }
            Text("Lunar")
                .font(.system(size: 19))
                .fontWeight(.medium)
        }
        .padding(.vertical, 8)
        .frame(width: UIScreen.main.bounds.width - 30)
            Spacer()
    }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
