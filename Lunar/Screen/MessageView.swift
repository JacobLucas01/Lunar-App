//
//  MessageView.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/9/22.
//

import SwiftUI
import Firebase

struct MessageView: View {
    //  @StateObject var users = RetrievePosts()
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<4, id: \.self) { user in
                            NavigationLink(destination: UserCommentsView()) {
                                MessageCell()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .navigationBarHidden(true)
        }
    }
}

struct MessageCell: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text("Jacob Lucas")
                    .font(.system(size: 18, weight: .semibold))
                Text("Last Message sent...")
                    .font(.system(size: 16))
                    .foregroundColor(Color(.systemGray2))
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 5) {
            Text("22h")
                    .font(.system(size: 14))
                .foregroundColor(Color(.systemGray2))
                Circle()
                    .frame(width: 17, height: 17)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.vertical, 10)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
